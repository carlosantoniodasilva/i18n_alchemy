require "active_record"
require "i18n"
require "i18n-alchemy/date_parser"
require "i18n-alchemy/numeric_parser"
require "i18n-alchemy/proxy"

module I18n
  module Alchemy
    def localized
      @i18n_alchemy_proxy ||= I18n::Alchemy::Proxy.new(self)
    end
  end
end
