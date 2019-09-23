require "test_helper"

class ProxyAttributesParsingTest < I18n::Alchemy::ProxyTestCase
  # Attributes
  def test_initializes_proxy_with_attributes
    @localized = @product.localized(
      name: "Banana", price: "0,99", released_at: "28/02/2011")

    assert_equal 0.99, @product.price
    assert_equal "0,99", @localized.price

    assert_equal Date.new(2011, 2, 28), @product.released_at
    assert_equal "28/02/2011", @localized.released_at
  end

  def test_assign_attributes
    @localized.assign_attributes(price: '1,99')
    assert_equal "1,99", @localized.price
  end

  def test_mass_assigning_invalid_attribute
    assert_raises(ActiveRecord::UnknownAttributeError) do
      @localized.assign_attributes('i_dont_even_exist' => 40)
    end
  end

  def test_assign_attributes_does_not_change_given_attributes_hash
    assert_attributes_hash_is_unchanged do |attributes|
      @localized.assign_attributes(attributes)
    end
  end

  def test_attributes_assignment
    @localized.attributes = { price: '1,99' }
    assert_equal "1,99", @localized.price
  end

  def test_attributes_assignment_does_not_change_given_attributes_hash
    assert_attributes_hash_is_unchanged do |attributes|
      @localized.attributes = attributes
    end
  end

  def test_update
    @localized.update(price: '2,88')
    assert_equal '2,88', @localized.price
    assert_equal 2.88, @product.reload.price
  end

  def test_update_does_not_change_given_attributes_hash
    assert_attributes_hash_is_unchanged do |attributes|
      @localized.update(attributes)
    end
  end

  def test_update_attributes
    @localized.update_attributes(price: '2,88')
    assert_equal '2,88', @localized.price
    assert_equal 2.88, @product.reload.price
  end

  def test_update!
    @localized.update!(price: '2,88')
    assert_equal '2,88', @localized.price
    assert_equal 2.88, @product.reload.price
  end

  def test_update_bang_does_not_change_given_attributes_hash
    assert_attributes_hash_is_unchanged do |attributes|
      @localized.update!(attributes)
    end
  end

  def test_update_attributes!
    @localized.update_attributes!(price: '2,88')
    assert_equal '2,88', @localized.price
    assert_equal 2.88, @product.reload.price
  end

  def test_update_attribute
    @localized.update_attribute(:price, '2,88')
    assert_equal '2,88', @localized.price
    assert_equal 2.88, @product.reload.price
  end

  # Nested Attributes
  def test_should_assign_for_nested_attributes_for_collection_association
    @supplier_localized.assign_attributes(products_attributes: [{ price: '1,99' }, { price: '2,93' }])
    assert_equal 2, @supplier_localized.products.size
    assert_equal '1,99', @supplier_localized.products.first.localized.price
    assert_equal '2,93', @supplier_localized.products.last.localized.price
  end

  def test_should_assign_for_nested_attributes_passing_a_hash_for_collection_with_unique_keys
    @supplier_localized.assign_attributes(products_attributes: { '0' => { price: '2,93', _destroy: 'false' }, '1' => { price: '2,85', _destroy: 'false' }})
    prices = @supplier.products.map { |p| p.localized.price }.sort
    assert_equal ['2,85', '2,93'], prices
  end

  def test_should_assign_for_nested_attributes_for_one_to_one_association
    @supplier_localized.assign_attributes(account_attributes: { account_number: 10, total_money: '100,87' })
    account = @supplier_localized.account
    assert_equal '10', account.account_number.to_s
    assert_equal '100,87', account.localized.total_money
  end

  def test_update_for_nested_attributes
    @supplier_localized.update(account_attributes: { total_money: '99,87' })
    assert_equal '99,87', @supplier_localized.account.localized.total_money
  end

  def test_attributes_assignment_for_nested
    @supplier_localized.attributes = { account_attributes: { total_money: '88,12' }}
    assert_equal '88,12', @supplier_localized.account.localized.total_money
  end

  private

  def assert_attributes_hash_is_unchanged
    attributes = { quantity: 1 }
    yield attributes
    assert_equal({ quantity: 1 }, attributes)
  end
end
