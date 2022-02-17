require 'rails_helper'

RSpec.describe Purchaser, type: :model do
  let(:name) { Faker::Company.unique.name }

  let(:purchaser) {
    build(
      :purchaser,
        name: name,
    )
  }

  before do
    purchaser.save
  end

  after do
    purchaser.destroy
  end

  it "is a valid purchaser" do
    expect(purchaser.valid?).to be true
  end

end
