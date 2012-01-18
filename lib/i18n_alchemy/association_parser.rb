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
      #  parse(:posts_attributes  => [{:title => 'Foo!'}, {:title => 'Bar!'}])
      #  parse(:posts_attributes => { 0 => {:title => 'Foo!'}, 1 => {:title => 'Bar!'})
      #  parse(:posts_attributes => { "81u21udjsndja" => {:title => 'Foo!'}, "akmsams" => {:title => 'Baz!'}})
      #
      def parse(attributes)
        if @association.macro == :has_many
          attributes = attributes.is_a?(Hash) ? attributes.values : attributes
          attributes.map { |value_attributes| @proxy.send(:parse_attributes, value_attributes) }
        else
          @proxy.send(:parse_attributes, attributes)
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
