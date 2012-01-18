require "test_helper"

class ProxyAttributesParsingTest < I18n::Alchemy::ProxyTestCase
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
