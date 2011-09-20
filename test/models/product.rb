class Product < ActiveRecord::Base
  include I18n::Alchemy

  attr_protected :my_precious

  belongs_to :supplier

  def method_with_block
    yield "called!"
  end
end
