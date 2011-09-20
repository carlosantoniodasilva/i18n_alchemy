module I18n
  module Alchemy
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
        @target.send(:"#{@attribute}=", parse(value))
      end

      def parse(value)
        @parser.parse(value)
      end
    end
  end
end