module I18n
  module Alchemy
    module ActiveRecord
      def write_attribute(attribute_name, value)
        value = parse_numeric_value(value) if numeric_column?(attribute_name)
        super
      end

      private

      def numeric_column?(attribute)
        column = column_for_attribute(attribute.to_s)
        [:decimal, :numeric, :float].include?(column.type)
      end

      def parse_numeric_value(value)
        numeric_parser.parse(value)
      end

      def numeric_parser
        @i18n_alchemy_numeric_parser ||= I18n::Alchemy::NumericParser.new
      end
    end
  end
end

ActiveRecord::Base.send :include, I18n::Alchemy::ActiveRecord
