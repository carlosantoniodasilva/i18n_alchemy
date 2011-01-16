module I18n
  module Alchemy
    module ActiveRecord
      # The default AR implementation of the reader methods does not
      # make use of read_attribute, it reads the @attributes hash and
      # uses the column type cast only. We need to use read_attribute
      # to make sure the attribute will be localized.
      # TODO: Review a possible better way of reading localized attributes
      def self.included(base)
        base.columns_hash.each_pair do |column_name, column|
          next if column.primary || !column.number?
          define_method(column_name) { read_attribute(column_name) }
          define_method("raw_#{column_name}") { read_attribute(column_name, true) }
        end
      end

      def read_attribute(attribute_name, raw=false)
        value = super(attribute_name)
        value = localize_numeric_value(value) if !raw && numeric_column?(attribute_name)
        value
      end

      def write_attribute(attribute_name, value)
        value = parse_numeric_value(value) if numeric_column?(attribute_name)
        super
      end

      private

      def numeric_column?(attribute)
        column_for_attribute(attribute.to_s).number?
      end

      def localize_numeric_value(value)
        numeric_parser.localize(value)
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
