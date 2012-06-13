class Person < ActiveRecord::Base
  include I18n::Alchemy
  localize :personable, :using => MyCustomAssociationParser

  belongs_to :personable, :polymorphic => true

  accepts_nested_attributes_for :personable

  def build_personable(attributes, options = {})
    self.personable = personable_type.constantize.new(attributes, options)
  end

  def self.i18n_alchemy_proxy
    Company.new
  end
end
