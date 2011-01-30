require "test_helper"

class ProxyTest < MiniTest::Unit::TestCase
  def setup
    @product   = Product.new
    @localized = @product.localized

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
  end

  def test_does_not_localize_primary_key
    @product.id = 1
    assert_equal 1, @localized.id
  end

  def test_does_not_localize_foreign_keys
    @product.supplier_id = 1
    assert_equal 1, @localized.supplier_id
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
    assert_equal Date.civil(2011, 2, 28), @product.released_at
  end

  def test_localizes_date_attribute_output
    @product.released_at = Date.civil(2011, 2, 28)
    assert_equal "28/02/2011", @localized.released_at
  end
end
