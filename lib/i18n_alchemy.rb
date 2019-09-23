require "date"
require "active_support"
require "active_support/core_ext/class/attribute"
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

    def localized(attributes = nil)
      I18n::Alchemy::Proxy.new(self, attributes)
    end

    included do
      class_attribute :localized_methods,
        instance_reader: false, instance_writer: false
      self.localized_methods = {}
    end

    module ClassMethods
      def localize(*methods, options)
        parser  = options[:using]
        methods = methods.each_with_object({}) do |method_name, hash|
          hash[method_name] = parser
        end
        self.localized_methods = self.localized_methods.merge(methods)
      end
    end
  end
end
