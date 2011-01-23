module I18n
  module Alchemy
    class Proxy
      class Attribute
        attr_reader :attribute

        def initialize(target, attribute, parser)
          @target    = target
          @attribute = attribute
          @parser    = parser
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

      instance_methods.each do |method|
        undef_method method unless method =~ /(^__|^send$|^object_id$)/
      end

      def initialize(target)
        @target = target

        parsers = {}
        @attributes = @target.class.columns.map do |column|
          next if column.primary

          parser = if column.number?
            :numeric
          elsif column.type == :date
            :date
          end

          if parser
            parser = parsers[parser] ||=
              I18n::Alchemy.const_get("#{parser.capitalize}Parser")

            Attribute.new(@target, column.name, parser.new)
          end
        end.compact
      end

      # TODO: is it the best option to rely only in method_missing?
      # Or should we define the right method when the proxy is created?
      def method_missing(method, *args, &block)
        attribute       = method.to_s
        proxy_attribute = find_localized_attribute(attribute.delete("="))

        if proxy_attribute
          if attribute.ends_with?("=")
            proxy_attribute.write(method, args.shift, *args, &block)
          else
            proxy_attribute.read(method, *args, &block)
          end
        else
          @target.send(method, *args, &block)
        end
      end

      private

      def find_localized_attribute(attribute)
        @attributes.detect { |c| c.attribute == attribute }
      end
    end
  end
end
