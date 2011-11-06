module I18n
  module Alchemy
    module NumericParser
      extend self

      def parse(value)
        if valid_for_parsing?(value)
          value.gsub(delimiter, '_').gsub(separator, '.')
        else
          value
        end
      end

      def localize(value)
        if valid_for_localization?(value)
          format("%.#{precision}f", value).gsub(".", separator)
        else
          value
        end
      end

      private

      def delimiter
        translate :delimiter
      end

      def precision
        translate :precision
      end

      def separator
        translate :separator
      end

      def translate(key)
        I18n.t(key, :scope => :"number.format")
      end

      def valid_for_localization?(value)
        value.is_a?(Numeric) && !value.is_a?(Integer)
      end

      def valid_for_parsing?(value)
        value.respond_to?(:gsub)
      end
    end
  end
end
