require "date"
require "active_record"
require "i18n"
require "i18n_alchemy/date_parser"
require "i18n_alchemy/time_parser"
require "i18n_alchemy/numeric_parser"
require "i18n_alchemy/attribute"
require "i18n_alchemy/association_parser"
require "i18n_alchemy/attributes_parsing"
require "i18n_alchemy/proxy"

module I18n
  module Alchemy
    extend ActiveSupport::Concern

    def localized(attributes=nil, *args)
      I18n::Alchemy::Proxy.new(self, attributes, *args)
    end

    included do
      class_attribute :localized, :instance_reader => false, :instance_writer => false
      self.localized = {}
    end

    module ClassMethods
      def localize(methods_hash)
        self.localized = self.localized.merge(methods_hash)
      end
    end
  end
end
