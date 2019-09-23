require "test_helper"

class ProxyTest < I18n::Alchemy::ProxyTestCase
  def test_delegates_orm_methods_to_target_object
    assert @product.new_record?
    assert @localized.save!(name: "foo", price: 1.99)
    assert !@product.new_record?
  end

  def test_delegates_method_with_block_to_target_object
    @localized.method_with_block do |attr|
      assert_equal "called!", attr
    end
  end

  def test_respond_to
    assert_respond_to @localized, :price
    assert_respond_to @localized, :price=
    assert_respond_to @localized, :name
    assert_respond_to @localized, :save
    assert_respond_to @localized, :method_with_block
  end

  def test_does_not_localize_primary_key
    @product.id = 1
    assert_equal 1, @localized.id
  end

  def test_to_json
    @supplier.products << @product
    assert_equal @supplier.to_json, @supplier_localized.to_json
  end

  def test_to_param
    @product.id = 1
    assert_equal @product.to_param, @localized.to_param
  end

  def test_does_not_localize_foreign_keys
    @product.supplier_id = 1
    assert_equal 1, @localized.supplier_id
  end

  def test_send
    @product.name = "Potato"
    assert_equal "Potato", @localized.send(:name)

    @product.price = 1.88
    assert_equal "1,88", @localized.send(:price)
    assert_equal "1,88", @localized.send(:price_before_type_cast)
  end

  def test_try
    @product.price = 1.99
    assert_equal "1,99", @localized.try(:price)
    assert_equal "1,99", @localized.try(:price_before_type_cast)
  end

  def test_try_with_block
    @localized.try :method_with_block do |attr|
      assert_equal "called!", attr
    end
  end

  # Numeric
  def test_parses_numeric_attribute_input
    @localized.price = "1,99"
    assert_equal 1.99, @product.price
  end

  def test_localizes_numeric_attribute_output
    @product.price = 1.88
    assert_equal "1,88", @localized.price
  end

  def test_localizes_numeric_attribute_before_type_cast_output
    @product.price = 1.88
    assert_equal "1,88", @localized.price_before_type_cast
  end

  def test_formats_numeric_attribute_output_when_localizing
    @product.price = 1.3
    assert_equal "1,30", @localized.price

    @product.price = 2
    assert_equal "2,00", @localized.price
  end

  def test_parsers_integer_attribute_input
    @localized.quantity = "1,0"
    assert_equal 1, @product.quantity
  end

  def test_localized_integer_attribute_output
    @product.quantity = 1.0
    assert_equal 1, @localized.quantity
  end

  def test_does_not_localize_other_attribute_input
    @localized.name = "foo"
    assert_equal "foo", @product.name
  end

  def test_does_not_localize_other_attribute_output
    @product.name = "foo"
    assert_equal "foo", @localized.name
  end

  # Date
  def test_parses_date_attribute_input
    @localized.released_at = "28/02/2011"
    assert_equal Date.new(2011, 2, 28), @product.released_at
  end

  def test_localizes_date_attribute_output
    @product.released_at = Date.new(2011, 2, 28)
    assert_equal "28/02/2011", @localized.released_at
  end

  def test_localizes_date_attribute_before_type_cast_output
    @product.released_at = Date.new(2011, 2, 28)
    assert_equal "28/02/2011", @localized.released_at_before_type_cast
  end

  # DateTime
  def test_parses_datetime_attribute_input
    @localized.updated_at = "28/02/2011 13:25:30"
    assert_equal Time.utc(2011,"feb",28,13,25,30), @product.updated_at
  end

  def test_localizes_datetime_attribute_output
    @product.updated_at = Time.utc(2011,"feb",28,13,25,30)
    assert_equal "28/02/2011 13:25:30", @localized.updated_at
  end

  def test_localizes_datetime_attribute_before_type_cast_output
    @product.updated_at = Time.utc(2011,"feb",28,13,25,30)
    assert_equal "28/02/2011 13:25:30", @localized.updated_at_before_type_cast
  end

  # Timestamp
  def test_parses_timestamp_attribute_input
    @localized.last_sale_at = "28/02/2011 13:25:30"
    assert_equal Time.utc(2011,"feb",28,13,25,30), @product.last_sale_at
  end

  def test_localizes_timestamp_attribute_output
    @product.last_sale_at = Time.utc(2011,"feb",28,13,25,30)
    assert_equal "28/02/2011 13:25:30", @localized.last_sale_at
  end

  def test_localizes_timestamp_attribute_before_type_cast_output
    @product.last_sale_at = Time.utc(2011,"feb",28,13,25,30)
    assert_equal "28/02/2011 13:25:30", @localized.last_sale_at_before_type_cast
  end

  # Custom parser
  def test_parses_date_attribute_input_with_custom_parser
    @localized.released_month = "02/2011"
    assert_equal Date.new(2011, 2, 1), @product.released_month
  end

  def test_localizes_date_attribute_output_with_custom_parser
    @product.released_month = Date.new(2011, 2, 1)
    assert_equal "02/2011", @localized.released_month
  end

  def test_localizes_date_attribute_before_type_cast_output_with_custom_parser
    @product.released_month = Date.new(2011, 2, 1)
    assert_equal "02/2011", @localized.released_month_before_type_cast
  end
end
