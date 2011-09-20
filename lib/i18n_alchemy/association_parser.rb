module I18n
  module Alchemy
    class AssociationParser
      attr_reader :target_class, :association_name

      def initialize(target_class, association_name)
        @target_class = target_class
        @association_name = association_name
        @association = @target_class.reflect_on_association(@association_name)
        @proxy = @association.klass.new.localized
      end

      # Parse nested attributes for one-to-one and collection association
      #
      # ==== Examples
      #
      #  parse(:avatar_attributes => {:icon => 'sad_panda'})
      #  parse(:posts_attributes => [{:title => 'Foo!'}, {:title => 'Bar!'}])
      #
      def parse(attributes)
        if attributes.is_a?(Hash)
          @proxy.send(:parse_attributes, attributes)
        else
          attributes.collect { |hash| @proxy.send(:parse_attributes, hash) }
        end
      end

      # ==== Examples
      #
      #   class Member < ActiveRecord::Base
      #     has_one :avatar
      #     accepts_nested_attributes_for :avatar
      #   end
      #
      #   AssociationParser.new(Member, :avatar).association_name_attributes # => "avatar_attributes"
      #
      def association_name_attributes
        "#{association_name}_attributes"
      end
    end
  end
end
