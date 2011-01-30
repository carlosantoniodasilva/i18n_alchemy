require "delegate"

module I18n
  module Alchemy
    class Proxy < DelegateClass(ActiveRecord::Base)
      class Attribute
        attr_reader :attribute

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
                  :numeric => NumericParser }

      def initialize(target)
        @localized_attributes = {}

        target.class.columns.each do |column|
          next if column.primary

          parser_type = case
          when column.number?
            :numeric
          when column.type == :date
            :date
          end

          if parser_type
            define_localized_method(target, column.name, parser_type)
          end
        end

        super(target)
      end

      private

      def define_localized_method(target, column_name, parser_type)
        attribute = Attribute.new(target, column_name, PARSERS[parser_type])
        @localized_attributes[column_name] = attribute

        instance_eval <<-ATTRIBUTE
          def #{column_name}
            @localized_attributes[#{column_name.inspect}].read
          end

          def #{column_name}=(new_value)
            @localized_attributes[#{column_name.inspect}].write(new_value)
          end
        ATTRIBUTE
      end
    end
  end
end
