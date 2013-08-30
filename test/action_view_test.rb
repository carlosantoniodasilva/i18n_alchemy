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
    assert_equal text_input(:name, 'Potato'),
      @template.text_field(:product, :name, :object => @localized)
  end

  def test_text_field_with_integer_attribute
    assert_equal text_input(:quantity, '10'),
      @template.text_field(:product, :quantity, :object => @localized)
  end

  def test_text_field_with_decimal_attribute
    assert_equal text_input(:price, '1,99'),
      @template.text_field(:product, :price, :object => @localized)
  end

  def test_text_field_with_date_attribute
    assert_equal text_input(:released_at, '28/02/2011'),
      @template.text_field(:product, :released_at, :object => @localized)
  end

  def test_text_field_with_time_attribute
    assert_equal text_input(:last_sale_at, '28/02/2011 13:25:30'),
      @template.text_field(:product, :last_sale_at, :object => @localized)
  end

  private

  def text_input(attribute_name, value)
    size = rails4? ? ' ' : ' size="30" '
    %Q[<input id="product_#{attribute_name}" name="product[#{attribute_name}]"#{size}type="text" value="#{value}" />]
  end

  def rails4?
    ActionPack::VERSION::STRING.start_with? "4"
  end
end
