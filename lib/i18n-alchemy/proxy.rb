module I18n
  module Alchemy
    class Proxy
      class BaseAttribute
        attr_reader :attribute

        # TODO: review: inject parser instead of having different classes?
        # TODO: this is gonna create a parser for each attribute, is this
        # really required?
        def initialize(target, attribute)
          @target    = target
          @attribute = attribute
        end

        def read(method, *args, &block)
          value = @target.send(method, *args, &block)
          @parser.localize(value)
        end

        def write(method, value, *args, &block)
          value = @parser.parse(value)
          @target.send(method, value, *args, &block)
        end
      end

      class DateAttribute < BaseAttribute
        def initialize(*)
          super
          @parser = I18n::Alchemy::DateParser.new
        end
      end

      class NumericAttribute < BaseAttribute
        def initialize(*)
          super
          @parser = I18n::Alchemy::NumericParser.new
        end
      end

      def initialize(target)
        @target = target

        @attributes = @target.class.columns.map do |column|
          next if column.primary

          if column.number?
            NumericAttribute.new(@target, column.name)
          elsif column.type == :date
            DateAttribute.new(@target, column.name)
          end
        end.compact
      end

      def method_missing(method, *args, &block)
        attribute = method.to_s
        is_writer = attribute.ends_with?("=")
        attribute = attribute.delete("=")
        column    = find_localized_column(attribute)

        if column
          if is_writer
            column.write(method, args.shift, *args, &block)
          else
            column.read(method, *args, &block)
          end
        else
          @target.send(method, *args, &block)
        end
      end

      def respond_to?(*args)
        @target.respond_to?(*args)
      end

      private

      def find_localized_column(attribute)
        @attributes.detect { |c| c.attribute == attribute }
      end
    end
  end
end
