require "test_helper"

class ModelsTest < I18n::Alchemy::TestCase
  def test_inheritance_configuration
    assert Supplier.localized_methods != AnotherSupplier.localized_methods
  end
end