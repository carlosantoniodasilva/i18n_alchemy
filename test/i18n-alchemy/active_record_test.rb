require "test_helper"

class ActiveRecordTest < MiniTest::Unit::TestCase
  def setup
    @product = Product.new
  end

  def test_numeric_columns_accept_numeric_values
    @product.price = 1.99
    assert_equal 1.99, @product.price
  end

  def test_numeric_columns_accept_string_values
    @product.price = "1.2"
    assert_equal 1.2, @product.price
  end

  def test_numeric_columns_accept_localized_values
    I18n.with_locale :pt do
      @product.price = "1,2"
      assert_equal 1.2, @product.price
    end
  end
end
