require 'rails_helper'

RSpec.describe Order, type: :model do

  purchaser = Purchaser.create(name: 'Sample purchaser')
  vendor = Vendor.create(name: 'Sample vendor')

  o_id = Order.last ? ( Order.last.id + 1) : 1
  order = Order.new(
    id: o_id,
    purchaser: purchaser,
    vendor: vendor,
    courrier: "#{['Fedex', 'UPS', 'USPS', 'DHL'].sample}",
  )

  order.build_order_content(
    id: o_id,
    order_id: o_id,
    box: "#{rand(0..15)}",
    crate:"#{rand(0..20)}",
    pallet:"#{rand(0..10)}",
    other:"#{rand(0..5)}",
    other_description: 'test data'
  )

  order.save

  it "is a valid order" do
    expect(order).to be_valid
  end
end
