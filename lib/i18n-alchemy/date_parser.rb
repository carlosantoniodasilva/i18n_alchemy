module I18n
  module Alchemy
    class DateParser
      # TODO: parse a list of possible input formats.
      # TODO: should the parse method return a string?
      # The receives the value (from user input for instance) and try to convert it to a valid Date.
      def parse(value)
        return value if value.is_a?(Date)

        Date.strptime(value, date_format).to_s rescue value
      end

      def localize(value)
        return value if value.is_a?(String)

        I18n.localize(value)
      end

      private

      def date_format
        I18n.t :default, :scope => [:date, :formats]
      end
    end
  end
end
