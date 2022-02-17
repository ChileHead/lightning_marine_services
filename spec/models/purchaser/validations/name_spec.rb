require 'rails_helper'

RSpec.describe Purchaser, type: :model do
  context "a valid name" do
    let(:name) { 'ValidPurchaserName' }

    let(:purchaser) {
      build(
        :purchaser,
          name: name,
      )
    }

    it "has a minimum length of 2 characters" do
      expect(purchaser.name.length).to be >= 2
      expect(purchaser).to be_valid
    end

    it "has a maximum length of 30 characters" do
      expect(purchaser.name.length).to be <= 30
      expect(purchaser).to be_valid
    end
  end

  context "an invalid name" do
    let(:purchaser) {
      build(
        :purchaser
      )
    }

    it "has less than 2 characters" do
      purchaser.name = 'x'
      expect(purchaser).to_not be_valid
    end

    it "has more than 30 characters" do
      purchaser.name = 'x'*31
      expect(purchaser).to_not be_valid
    end
  end
end
