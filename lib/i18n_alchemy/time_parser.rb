module I18n
  module Alchemy
    module TimeParser
      extend self

      # TODO: parse a list of possible input formats.
      # TODO: should the parse method return a string?
      # The receives the value (from user input for instance) and try to
      # convert it to a valid Time.
      def parse(value)
        return value if value.is_a?(DateTime)

        if parsed_date = DateTime._strptime(value, date_format)
          DateTime.new(*parsed_date.values_at(
            :year, :mon, :mday, :hour, :min, :sec)).to_s
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
        I18n.t :default, :scope => [:time, :formats]
      end
    end
  end
end
