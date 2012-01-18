require "test_helper"

class ProxyMethodsTest < I18n::Alchemy::ProxyTestCase
  def test_localizes_numeric_methods
    @product.price    = 1.99
    @product.quantity = 10

    assert_equal 19.90, @product.total
    assert_equal "19,90", @localized.total
  end

  def test_localizes_date_methods
    @product.released_at = Date.new(2011, 2, 28)
    assert_equal "05/03/2011", @localized.estimated_delivery_at
  end

  def test_localizes_time_methods
    @product.last_sale_at = Time.mktime(2011, 2, 28, 13, 25, 30)
    assert_equal "05/03/2011 23:59:59", @localized.estimated_last_comission_payment_at
  end
end
