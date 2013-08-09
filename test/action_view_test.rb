require "test_helper"

class ActionViewTest < I18n::Alchemy::TestCase
  def setup
    @template  = ActionView::Base.new
    @product   = Product.new(
      :name         => "Potato",
      :quantity     => 10,
      :price        => 1.99,
      :released_at  => Date.new(2011, 2, 28),
      :last_sale_at => Time.mktime(2011, 2, 28, 13, 25, 30)
    )
    @localized = @product.localized

    I18n.locale = :pt
  end

  def teardown
    I18n.locale = :en
  end

  def test_text_field_with_string_attribute
    assert_equal '<input id="product_name" name="product[name]" type="text" value="Potato" />',
      @template.text_field(:product, :name, :object => @localized)
  end

  def test_text_field_with_integer_attribute
    assert_equal '<input id="product_quantity" name="product[quantity]" type="text" value="10" />',
      @template.text_field(:product, :quantity, :object => @localized)
  end

  def test_text_field_with_decimal_attribute
    assert_equal '<input id="product_price" name="product[price]" type="text" value="1,99" />',
      @template.text_field(:product, :price, :object => @localized)
  end

  def test_text_field_with_date_attribute
    assert_equal '<input id="product_released_at" name="product[released_at]" type="text" value="28/02/2011" />',
      @template.text_field(:product, :released_at, :object => @localized)
  end

  def test_text_field_with_time_attribute
    assert_equal '<input id="product_last_sale_at" name="product[last_sale_at]" type="text" value="28/02/2011 13:25:30" />',
      @template.text_field(:product, :last_sale_at, :object => @localized)
  end
end
