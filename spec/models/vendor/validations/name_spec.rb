require 'rails_helper'

RSpec.describe Vendor, type: :model do
  context "a valid name" do
    let(:name) { 'ValidVendorName' }

    let(:vendor) {
      build(
        :vendor,
          name: name,
      )
    }

    it "has a minimum length of 2 characters" do
      expect(vendor.name.length).to be >= 2
      expect(vendor).to be_valid
    end

    it "has a maximum length of 30 characters" do
      expect(vendor.name.length).to be <= 30
      expect(vendor).to be_valid
    end
  end

  context "an invalid name" do
    let(:vendor) {
      build(
        :vendor
      )
    }

    it "has less than 2 characters" do
      vendor.name = 'x'
      expect(vendor).to_not be_valid
    end

    it "has more than 30 characters" do
      vendor.name = 'x'*31
      expect(vendor).to_not be_valid
    end
  end
end
