require 'rails_helper'

RSpec.describe Vendor, type: :model do
  let(:name) { Faker::Company.unique.name }

  let(:vendor) {
    build(
      :vendor,
        name: name,
    )
  }

  before do
    vendor.save
  end

  after do
    vendor.destroy
  end

  it "is a valid vendor" do
    expect(vendor).to be_valid
  end

end
