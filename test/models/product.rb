class Product < ActiveRecord::Base
  include I18n::Alchemy
  localize :total => :number, :estimated_delivery_at => MyCustomDateParser,
    :estimated_last_comission_payment_at => :timestamp
  custom_parsers :released_month => MyCustomDateParser

  attr_protected :my_precious

  belongs_to :supplier

  def method_with_block
    yield "called!"
  end

  def estimated_last_comission_payment_at
    (last_sale_at + 5.days).end_of_day if last_sale_at?
  end

  def estimated_delivery_at
    released_at + 5.days if released_at?
  end

  def total
    @total || (quantity * price if quantity? && price?)
  end

  def total=(new_total)
    @total = new_total
  end
end
