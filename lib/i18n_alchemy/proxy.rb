module I18n
  module Alchemy
    # Depend on AS::BasicObject which has a "blank slate" - no methods.
    class Proxy < ActiveSupport::BasicObject
      class Attribute
        def initialize(target, attribute, parser)
          @target    = target
          @attribute = attribute
          @parser    = parser
        end

        def read
          @parser.localize(@target.send(@attribute))
        end

        def write(value)
          @target.send(:"#{@attribute}=", @parser.parse(value))
        end
      end

      # TODO: cannot assume _id is always a foreign key.
      # Find a better way to find that and skip these columns.
      def initialize(target, attributes=nil)
        @target = target
        @localized_attributes = {}
        attributes = Array(attributes) if attributes

        @target.class.columns.each do |column|
          next if column.primary || column.name.ends_with?("_id")
          next if attributes && !attributes.include?(column.name.to_sym)

          parser = detect_parser(column)
          if parser
            create_localized_attribute(column.name, parser)
            define_localized_methods(column.name)
          end
        end
      end

      # Override to_model to always return the proxy, otherwise it returns the
      # target object. This allows us to integrate with action view.
      def to_model
        self
      end

      # Allow calling the localized methods with :send. This allows us to
      # integrate with action view methods.
      alias :send :__send__

      # Delegate all method calls that are not translated to the target object.
      # As the proxy does not have any other method, there is no need to
      # override :respond_to, just delegate it to the target as well.
      def method_missing(*args, &block)
        @target.send *args, &block
      end

      private

      def create_localized_attribute(column_name, parser)
        @localized_attributes[column_name] =
          Attribute.new(@target, column_name, parser)
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

      def detect_parser(column)
        case
        when column.number?
          NumericParser
        when column.type == :date
          DateParser
        when column.type == :datetime || column.type == :timestamp
          TimeParser
        end
      end
    end
  end
end
