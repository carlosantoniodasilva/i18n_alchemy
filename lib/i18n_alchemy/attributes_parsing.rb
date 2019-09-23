module I18n
  module Alchemy
    module AttributesParsing
      def attributes=(attributes)
        @target.attributes = parse_attributes(attributes)
      end

      def assign_attributes(attributes)
        @target.assign_attributes(parse_attributes(attributes))
      end

      def update_attributes(attributes)
        @target.update_attributes(parse_attributes(attributes))
      end

      def update_attributes!(attributes)
        @target.update_attributes!(parse_attributes(attributes))
      end

      def update(attributes)
        @target.update(parse_attributes(attributes))
      end

      def update!(attributes)
        @target.update!(parse_attributes(attributes))
      end

      def update_attribute(attribute, value)
        attributes = parse_attributes(attribute => value)
        @target.update_attribute(attribute, attributes.values.first)
      end

      private

      def parse_attributes(attributes)
        attributes = attributes.stringify_keys

        @localized_attributes.each do |column_name, attribute|
          next unless attributes.key?(column_name)
          attributes[column_name] = attribute.parse(attributes[column_name])
        end
        @localized_associations.each do |association_parser|
          association_name = association_parser.association_name_attributes
          next unless attributes.key?(association_name)
          attributes[association_name] = association_parser.parse(attributes[association_name])
        end

        attributes
      end
    end
  end
end
