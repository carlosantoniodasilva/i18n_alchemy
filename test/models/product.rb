class Product < ActiveRecord::Base
  include I18n::Alchemy
  localize_methods :total => :number, :estimated_delivery_at => :date,
    :estimated_last_comission_payment_at => :timestamp

  attr_protected :my_precious

  belongs_to :supplier

  def method_with_block
    yield "called!"
  end

  def estimated_last_comission_payment_at
    (last_sale_at + 5.days).end_of_day
  end

  def estimated_delivery_at
    released_at + 5.days
  end

  def total
    quantity * price
  end
end
