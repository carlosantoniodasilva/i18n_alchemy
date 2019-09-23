module I18n
  module Alchemy
    module DateParser
      extend self

      def parse(value)
        return value unless valid_for_parsing?(value)

        if parsed_date = Date._strptime(value, i18n_format)
          build_object(parsed_date).to_s
        else
          value
        end
      end

      def localize(value)
        valid_for_localization?(value) ? I18n.localize(value) : value
      end

      protected

      def build_object(parsed_date)
        Date.new(*extract_date(parsed_date))
      end

      def extract_date(parsed_date)
        parsed_date.values_at(:year, :mon, :mday).compact
      end

      def i18n_format
        I18n.t(:default, scope: [i18n_scope, :formats])
      end

      def i18n_scope
        :date
      end

      def valid_for_localization?(value)
        value.is_a?(Date)
      end

      def valid_for_parsing?(value)
        !valid_for_localization?(value)
      end
    end
  end
end
