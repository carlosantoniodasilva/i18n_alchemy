module I18n
  module Alchemy
    module DateParser
      extend self

      def parse(value)
        return value if value.is_a?(Date)

        if parsed_date = Date._strptime(value, date_format)
          Date.new(*parsed_date.values_at(:year, :mon, :mday)).to_s
        else
          value
        end
      end

      def localize(value)
        value.is_a?(String) ? value : I18n.localize(value)
      end

      private

      def date_format
        I18n.t :default, :scope => [:date, :formats]
      end
    end
  end
end
