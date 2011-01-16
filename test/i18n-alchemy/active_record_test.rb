require "test_helper"

class ActiveRecordTest < MiniTest::Unit::TestCase
  def setup
    @product = Product.new
  end

  def test_numeric_columns_accept_and_convert_numeric_values
    @product.price = 1.99
    assert_equal "1.99", @product.price
  end

  def test_numeric_columns_accept_and_convert_string_values
    @product.price = "1.2"
    assert_equal "1.2", @product.price
  end

  def test_numeric_columns_accept_and_convert_localized_values
    I18n.with_locale :pt do
      @product.price = "1,2"
      assert_equal "1,2", @product.price
    end
  end

  def test_raw_numeric_attribute
    @product.price = 1.99
    assert_equal 1.99, @product.raw_price
  end

  def test_raw_numeric_attribute_with_different_locale
    I18n.with_locale :pt do
      @product.price = 1.99
      assert_equal 1.99, @product.raw_price
    end
  end

  def test_does_not_use_localization_on_primary_key_column
    @product.id = 123
    assert_equal 123, @product.id
  end
end
