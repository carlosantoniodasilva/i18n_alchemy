require "date"
require "active_record"
require "i18n"
require "i18n_alchemy/date_parser"
require "i18n_alchemy/time_parser"
require "i18n_alchemy/numeric_parser"
require "i18n_alchemy/proxy"
require "i18n_alchemy/attributes"

module I18n
  module Alchemy
    def localized(attributes=nil)
      I18n::Alchemy::Proxy.new(self, attributes)
    end
  end
end
