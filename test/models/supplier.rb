class Supplier < ActiveRecord::Base
  include I18n::Alchemy

  has_many :products
  has_one  :account

  accepts_nested_attributes_for :products
  accepts_nested_attributes_for :account
end

class AnotherSupplier < Supplier
  localize :created_at, using: :timestamp
end