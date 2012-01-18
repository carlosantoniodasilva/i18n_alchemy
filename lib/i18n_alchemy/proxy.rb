module I18n
  module Alchemy
    # Depend on AS::BasicObject which has a "blank slate" - no methods.
    class Proxy < ActiveSupport::BasicObject
      # TODO: cannot assume _id is always a foreign key.
      # Find a better way to find that and skip these columns.
      def initialize(target, attributes=nil, *args)
        @target = target
        @localized_attributes = {}

        @target.class.columns.each do |column|
          next if column.primary || column.name.ends_with?("_id")

          parser = detect_parser_from_column(column)
          build_attribute(column.name, parser)
        end

        @target.localized_methods.each_pair do |method, parser_type|
          method = method.to_s
          parser = detect_parser(parser_type)
          build_attribute(method, parser)
        end

        @localized_associations = @target.class.nested_attributes_options.map do |association_name, options|
          ::I18n::Alchemy::AssociationParser.new(@target.class, association_name)
        end

        assign_attributes(attributes, *args) if attributes
      end

      def attributes=(attributes)
        @target.attributes = parse_attributes(attributes)
      end

      # This method is added to the proxy even thought it does not exist in
      # Rails 3.0 (only >= 3.1).
      def assign_attributes(attributes, *args)
        if @target.respond_to?(:assign_attributes)
          @target.assign_attributes(parse_attributes(attributes), *args)
        else
          self.attributes = attributes
        end
      end

      def update_attributes(attributes, *args)
        @target.update_attributes(parse_attributes(attributes), *args)
      end

      def update_attributes!(attributes, *args)
        @target.update_attributes!(parse_attributes(attributes), *args)
      end

      def update_attribute(attribute, value)
        attributes = parse_attributes(attribute => value)
        @target.update_attribute(attribute, attributes.values.first)
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

      def build_attribute(name, parser)
        return unless parser
        create_localized_attribute(name, parser)
        define_localized_methods(name)
      end

      def create_localized_attribute(column_name, parser)
        @localized_attributes[column_name] =
          ::I18n::Alchemy::Attribute.new(@target, column_name, parser)
      end

      def define_localized_methods(column_name)
        class << self; self; end.instance_eval do
          define_method(column_name) do
            @localized_attributes[column_name].read
          end

          # Before type cast must be localized to integrate with action view.
          define_method("#{column_name}_before_type_cast") do
            @localized_attributes[column_name].read
          end

          define_method("#{column_name}=") do |value|
            @localized_attributes[column_name].write(value)
          end
        end
      end

      def detect_parser_from_column(column)
        detect_parser(column.number? ? :number : column.type)
      end

      def detect_parser(type)
        case type
        when :number
          NumericParser
        when :date
          DateParser
        when :datetime, :timestamp
          TimeParser
        end
      end

      def parse_attributes(attributes)
        attributes = attributes.stringify_keys

        @localized_attributes.each do |column_name, attribute|
          next unless attributes.key?(column_name)
          attributes[column_name] = attribute.parse(attributes[column_name])
        end
        @localized_associations.each do |association_parser|
          association_attributes = association_parser.association_name_attributes
          next unless attributes.key?(association_attributes)
          attributes[association_attributes] = association_parser.parse(attributes[association_attributes])
        end

        attributes
      end
    end
  end
end
