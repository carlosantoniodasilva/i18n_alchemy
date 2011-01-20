module I18n
  module Alchemy
    class Proxy
      def initialize(target)
        @target = target

        @attributes = @target.class.columns.select do |column|
          !column.primary && column.number?
        end.map { |column| column.name }
      end

      def method_missing(method, *args, &block)
        attribute = method.to_s
        is_writer = attribute.ends_with?("=")
        attribute = attribute.delete("=")

        if @attributes.include?(attribute)
          if is_writer
            write_attribute(method, args.shift, *args, &block)
          else
            read_attribute(method, *args, &block)
          end
        else
          @target.send(method, *args, &block)
        end
      end

      def respond_to?(*args)
        @target.respond_to?(*args)
      end

      private

      def read_attribute(method, *args, &block)
        value = @target.send(method, *args, &block)
        localize_numeric_value(value)
      end

      def write_attribute(method, value, *args, &block)
        value = parse_numeric_value(value)
        @target.send(method, value, *args, &block)
      end

      def localize_numeric_value(value)
        numeric_parser.localize(value)
      end

      def parse_numeric_value(value)
        numeric_parser.parse(value)
      end

      def numeric_parser
        @numeric_parser ||= I18n::Alchemy::NumericParser.new
      end
    end
  end
end
