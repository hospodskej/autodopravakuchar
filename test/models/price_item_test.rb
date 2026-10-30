require "test_helper"

class PriceItemTest < ActiveSupport::TestCase
  test "requires category and name" do
    item = PriceItem.new
    assert_not item.valid?
    assert_includes item.errors.attribute_names, :category
    assert_includes item.errors.attribute_names, :name
  end

  test "rejects negative price" do
    assert_not PriceItem.new(category: "Dovoz", name: "Písek", price: -1).valid?
  end

  test "nil price means priced individually" do
    assert PriceItem.new(category: "Práce", name: "Bagr").priced_individually?
  end
end
