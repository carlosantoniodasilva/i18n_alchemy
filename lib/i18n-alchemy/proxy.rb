module I18n
  module Alchemy
    class Proxy
      def initialize(target)
        @target = target

        @columns = @target.class.columns.select do |column|
          !column.primary && (column.number? || column.type == :date)
        end
      end

      def method_missing(method, *args, &block)
        attribute = method.to_s
        is_writer = attribute.ends_with?("=")
        attribute = attribute.delete("=")
        column    = find_localized_column(attribute)

        if column
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

      def find_localized_column(attribute)
        @columns.detect { |c| c.name == attribute }
      end

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
