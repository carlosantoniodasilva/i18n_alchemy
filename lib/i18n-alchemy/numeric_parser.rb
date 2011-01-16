module I18n
  module Alchemy
    class NumericParser
      def parse(value)
        return value if value.is_a?(Numeric)

        value.gsub(delimiter, '_').gsub(separator, '.')
      end

      def localize(value)
        return value if value.is_a?(String)

        value.to_s.gsub("_", "separator").gsub(".", separator)
      end

      private

      def delimiter
        translate :delimiter
      end

      def separator
        translate :separator
      end

      def translate(key)
        I18n.t(key, :scope => :"number.format")
      end
    end
  end
end
