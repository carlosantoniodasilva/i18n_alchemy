module I18n
  module Alchemy
    class NumericParser
      def parse(number)
        return number if number.is_a?(Numeric)

        number.gsub(delimiter, '_').gsub(separator, '.')
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
