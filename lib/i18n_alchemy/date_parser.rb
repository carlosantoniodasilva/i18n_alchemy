module I18n
  module Alchemy
    module DateParser
      extend self

      # TODO: parse a list of possible input formats.
      # TODO: should the parse method return a string?
      # The receives the value (from user input for instance) and try to
      # convert it to a valid Date.
      def parse(value)
        return value if value.is_a?(Date)

        if parsed_date = Date._strptime(value, date_format)
          Date.new(*parsed_date.values_at(:year, :mon, :mday)).to_s
        else
          value
        end
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
