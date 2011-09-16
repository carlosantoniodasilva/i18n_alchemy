require "date"
require "active_record"
require "i18n"
require "i18n_alchemy/date_parser"
require "i18n_alchemy/time_parser"
require "i18n_alchemy/numeric_parser"
require "i18n_alchemy/proxy"

module I18n
  module Alchemy
    def localized(attributes=nil, *args)
      I18n::Alchemy::Proxy.new(self, attributes, *args)
    end
  end
end
