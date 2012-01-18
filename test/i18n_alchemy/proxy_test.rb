require "test_helper"

class ProxyTest < MiniTest::Unit::TestCase
  def setup
    @product   = Product.new
    @localized = @product.localized
    @supplier  = Supplier.new
    @supplier_localized = @supplier.localized

    I18n.locale = :pt
  end

  def teardown
    I18n.locale = :en
  end

  def test_delegates_orm_methods_to_target_object
    assert @product.new_record?
    assert @localized.save!(:name => "foo", :price => 1.99)
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

  def test_to_param
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
    assert_equal Time.mktime(2011, 2, 28, 13, 25, 30), @product.updated_at
  end

  def test_localizes_datetime_attribute_output
    @product.updated_at = Time.mktime(2011, 2, 28, 13, 25, 30)
    assert_equal "28/02/2011 13:25:30", @localized.updated_at
  end

  def test_localizes_datetime_attribute_before_type_cast_output
    @product.updated_at = Time.mktime(2011, 2, 28, 13, 25, 30)
    assert_equal "28/02/2011 13:25:30", @localized.updated_at_before_type_cast
  end

  # Timestamp
  def test_parses_timestamp_attribute_input
    @localized.last_sale_at = "28/02/2011 13:25:30"
    assert_equal Time.mktime(2011, 2, 28, 13, 25, 30), @product.last_sale_at
  end

  def test_localizes_timestamp_attribute_output
    @product.last_sale_at = Time.mktime(2011, 2, 28, 13, 25, 30)
    assert_equal "28/02/2011 13:25:30", @localized.last_sale_at
  end

  def test_localizes_timestamp_attribute_before_type_cast_output
    @product.last_sale_at = Time.mktime(2011, 2, 28, 13, 25, 30)
    assert_equal "28/02/2011 13:25:30", @localized.last_sale_at_before_type_cast
  end

  # Attributes
  def test_initializes_proxy_with_attributes
    @localized = @product.localized(
      :name => "Banana", :price => "0,99", :released_at => "28/02/2011")

    assert_equal 0.99, @product.price
    assert_equal "0,99", @localized.price

    assert_equal Date.new(2011, 2, 28), @product.released_at
    assert_equal "28/02/2011", @localized.released_at
  end

  def test_initializes_proxy_with_attributes_and_skips_mass_assignment_security_protection_when_without_protection_is_used
    @localized = @product.localized(attributes_hash, :without_protection => true)
    if support_assign_attributes_without_protection?
      assert_equal 'My Precious!', @localized.my_precious
    else
      assert_nil @localized.my_precious
    end
    assert_equal 1, @localized.quantity
  end

  def test_assign_attributes
    @localized.assign_attributes(:price => '1,99')
    assert_equal "1,99", @localized.price
  end

  def test_mass_assigning_invalid_attribute
    assert_raises(ActiveRecord::UnknownAttributeError) do
      @localized.assign_attributes('i_dont_even_exist' => 40)
    end
  end

  def test_new_with_attr_protected_attributes
    @localized.assign_attributes(attributes_hash)
    assert_nil @localized.my_precious
    assert_equal 1, @localized.quantity
  end

  def test_assign_attributes_skips_mass_assignment_security_protection_when_without_protection_is_used
    @localized.assign_attributes(attributes_hash, :without_protection => true)
    if support_assign_attributes_without_protection?
      assert_equal 'My Precious!', @localized.my_precious
    else
      assert_nil @localized.my_precious
    end
    assert_equal 1, @localized.quantity
  end

  def test_assign_attributes_does_not_change_given_attributes_hash
    assert_attributes_hash_is_not_changed(attributes = attributes_hash) do
      @localized.assign_attributes(attributes)
    end
  end

  def test_attributes_assignment
    @localized.attributes = { :price => '1,99' }
    assert_equal "1,99", @localized.price
  end

  def test_attributes_assignment_does_not_change_given_attributes_hash
    assert_attributes_hash_is_not_changed(attributes = attributes_hash) do
      @localized.attributes = attributes
    end
  end

  def test_update_attributes
    @localized.update_attributes(:price => '2,88')
    assert_equal '2,88', @localized.price
    assert_equal 2.88, @product.reload.price
  end

  def test_update_attributes_does_not_change_given_attributes_hash
    assert_attributes_hash_is_not_changed(attributes = attributes_hash) do
      @localized.update_attributes(attributes)
    end
  end

  def test_update_attributes!
    @localized.update_attributes!(:price => '2,88')
    assert_equal '2,88', @localized.price
    assert_equal 2.88, @product.reload.price
  end

  def test_update_attributes_bang_does_not_change_given_attributes_hash
    assert_attributes_hash_is_not_changed(attributes = attributes_hash) do
      @localized.update_attributes!(attributes)
    end
  end

  def test_update_attribute
    @localized.update_attribute(:price, '2,88')
    assert_equal '2,88', @localized.price
    assert_equal 2.88, @product.reload.price
  end

  # Nested Attributes
  def test_should_assign_for_nested_attributes_for_collection_association
    @supplier_localized.assign_attributes(:products_attributes => [{:price => '1,99'}, {:price => '2,93'}])
    assert_equal 2, @supplier_localized.products.size
    assert_equal '1,99', @supplier_localized.products.first.localized.price
    assert_equal '2,93', @supplier_localized.products.last.localized.price
  end

  def test_should_assign_for_nested_attributes_passing_a_hash_for_collection_with_unique_keys
    @supplier_localized.assign_attributes(:products_attributes => {"0" => {:price => '2,93', "_destroy"=>"false"}, "1" => {:price => '2,85', "_destroy" => "false"}})
    prices = @supplier.products.map { |p| p.localized.price }.sort
    assert_equal ['2,85', '2,93'], prices
  end

  def test_should_assign_for_nested_attributes_for_one_to_one_association
    @supplier_localized.assign_attributes(:account_attributes => {:account_number => 10, :total_money => '100,87'})
    account = @supplier_localized.account
    assert_equal 10, account.account_number
    assert_equal '100,87', account.localized.total_money
  end

  def test_update_attributes_for_nested_attributes
    @supplier_localized.update_attributes(:account_attributes => {:total_money => '99,87'})
    assert_equal '99,87', @supplier_localized.account.localized.total_money
  end

  def test_attributes_assignment_for_nested
    @supplier_localized.attributes = {:account_attributes => {:total_money => '88,12'}}
    assert_equal '88,12', @supplier_localized.account.localized.total_money
  end

  # Methods
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

  private

  def attributes_hash
    { :my_precious => 'My Precious!', :quantity => 1 }
  end

  def assert_attributes_hash_is_not_changed(attributes)
    yield
    assert_equal 1, attributes[:quantity]
    assert_equal 'My Precious!', attributes[:my_precious]
  end
end
