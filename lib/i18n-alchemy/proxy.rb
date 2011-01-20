module I18n
  module Alchemy
    class Proxy
      def initialize(target)
        @target = target

        @attributes = @target.class.columns.select do |column|
          !column.primary && column.number?
        end.map { |column| column.name }
      end

      def method_missing(method, *args)
        attribute = method.to_s
        is_writer = attribute.ends_with?("=")
        attribute = attribute.delete("=")
        if @attributes.include?(attribute)
          if is_writer
            value = parse_numeric_value(args.shift)
            args.unshift(value)
            @target.send(method, *args)
          else
            value = @target.send(method, *args)
            localize_numeric_value(value)
          end
        else
          @target.send(method, *args)
        end
      end

      def respond_to?(*args)
        @target.respond_to?(*args)
      end

      private

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
