module I18n
  module Alchemy
    module TimeParser
      extend self

      def parse(value)
        return value if value.is_a?(Time) || value.is_a?(DateTime)

        if parsed_date = Date._strptime(value, time_format)
          Time.new(*parsed_date.values_at(
            :year, :mon, :mday, :hour, :min, :sec)).to_s
        else
          value
        end
      end

      def localize(value)
        value.is_a?(String) ? value : I18n.localize(value)
      end

      private

      def time_format
        I18n.t :default, :scope => [:time, :formats]
      end
    end
  end
end
