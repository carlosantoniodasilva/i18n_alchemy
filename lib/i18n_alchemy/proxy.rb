require "delegate"

module I18n
  module Alchemy
    class Proxy < DelegateClass(ActiveRecord::Base)
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
        @localized_attributes = {}
        attributes = Array(attributes) if attributes

        target.class.columns.each do |column|
          next if column.primary || column.name.ends_with?("_id")
          next if attributes && !attributes.include?(column.name.to_sym)

          parser = detect_parser(column)
          if parser
            create_localized_attribute(target, column.name, parser)
            define_localized_methods(column.name)
          end
        end

        super(target)
      end

      private

      def create_localized_attribute(target, column_name, parser)
        @localized_attributes[column_name] =
          Attribute.new(target, column_name, parser)
      end

      def define_localized_methods(column_name)
        singleton_class.instance_eval do
          define_method(column_name) do
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
