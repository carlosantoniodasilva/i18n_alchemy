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
          value = @target.send(@attribute)
          @parser.localize(value)
        end

        def write(value)
          value = @parser.parse(value)
          @target.send(:"#{@attribute}=", value)
        end
      end

      PARSERS = { :date    => DateParser,
                  :time    => TimeParser,
                  :numeric => NumericParser }

      # TODO: cannot assume _id is always a foreign key.
      # Find a better way to find that and skip these columns.
      def initialize(target)
        @localized_attributes = {}

        target.class.columns.each do |column|
          next if column.primary || column.name.ends_with?("_id")

          parser_type = detect_parser_type(column)
          if parser_type
            create_localized_attribute(target, column.name, parser_type)
            define_localized_methods(column.name)
          end
        end

        super(target)
      end

      private

      def create_localized_attribute(target, column_name, parser_type)
        attribute = Attribute.new(target, column_name, PARSERS[parser_type])
        @localized_attributes[column_name] = attribute
      end

      def define_localized_methods(column_name)
        instance_eval <<-ATTRIBUTE
          def #{column_name}
            @localized_attributes[#{column_name.inspect}].read
          end

          def #{column_name}=(new_value)
            @localized_attributes[#{column_name.inspect}].write(new_value)
          end
        ATTRIBUTE
      end

      def detect_parser_type(column)
        case
        when column.number?
          :numeric
        when column.type == :date
          :date
        when column.type == :datetime || column.type == :timestamp
          :time
        end
      end
    end
  end
end
