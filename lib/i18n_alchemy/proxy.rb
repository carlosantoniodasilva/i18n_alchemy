module I18n
  module Alchemy
    # Depend on AS::BasicObject which has a "blank slate" - no methods.
    class Proxy < ActiveSupport::BasicObject
      include AttributesParsing

      # TODO: cannot assume _id is always a foreign key.
      # Find a better way to find that and skip these columns.
      def initialize(target, attributes=nil, *args)
        @target = target

        @localized_attributes = {}
        build_attributes
        build_methods

        @localized_associations = []
        build_associations

        assign_attributes(attributes, *args) if attributes
      end

      # Override to_param to always return the +proxy.to_param+. This allow us
      # to integrate with action view.
      def to_param
        @target.to_param
      end

      # Override to_model to always return the proxy, otherwise it returns the
      # target object. This allows us to integrate with action view.
      def to_model
        self
      end

      # Allow calling localized methods with :send. This allows us to integrate
      # with action view methods.
      alias :send :__send__

      # Allow calling localized methods with :try. If the method is not declared
      # here, it'll be delegated to the target, losing localization capabilities.
      def try(*a, &b)
        __send__(*a, &b)
      end

      # Delegate all method calls that are not translated to the target object.
      # As the proxy does not have any other method, there is no need to
      # override :respond_to, just delegate it to the target as well.
      def method_missing(*args, &block)
        @target.send(*args, &block)
      end

      private

      def build_attributes
        @target.class.columns.each do |column|
          next if column.primary || column.name.ends_with?("_id")

          parser = @target.class.customized_parsers[column.name.to_sym] || detect_parser_from_column(column)
          build_attribute(column.name, parser)
        end
      end

      def build_methods
        @target.class.localized_methods.each_pair do |method, parser_type|
          method = method.to_s
          parser = detect_parser(parser_type)
          build_attribute(method, parser)
        end
      end

      def build_associations
        @target.class.nested_attributes_options.each_key do |association_name|
          create_localized_association(association_name)
        end
      end

      def build_attribute(name, parser)
        return unless parser
        create_localized_attribute(name, parser)
        define_localized_methods(name)
      end

      def create_localized_association(association_name)
        @localized_associations <<
          AssociationParser.new(@target.class, association_name)
      end

      def create_localized_attribute(column_name, parser)
        @localized_attributes[column_name] =
          Attribute.new(@target, column_name, parser)
      end

      def define_localized_methods(column_name)
        target = @target
        class << self; self; end.instance_eval do
          define_method(column_name) do
            @localized_attributes[column_name].read
          end

          # Before type cast must be localized to integrate with action view.
          method_name = "#{column_name}_before_type_cast"
          define_method(method_name) do
            @localized_attributes[column_name].read
          end if target.respond_to?(method_name)

          method_name = "#{column_name}="
          define_method(method_name) do |value|
            @localized_attributes[column_name].write(value)
          end if target.respond_to?(method_name)
        end
      end

      def detect_parser_from_column(column)
        detect_parser(column.number? ? :number : column.type)
      end

      def detect_parser(type_or_parser)
        case type_or_parser
        when :number
          NumericParser
        when :date
          DateParser
        when :datetime, :timestamp
          TimeParser
        when ::Module
          type_or_parser
        end
      end
    end
  end
end
