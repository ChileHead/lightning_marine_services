require 'rails_helper'

RSpec.describe User, type: :model do
  let(:last_name) { Faker::Name.unique.last_name }

  let(:user) {
    build(
      :user,
        last_name: last_name,
    )
  }

  before do
    user.skip_confirmation!
    user.save
  end

  after do
    user.destroy
  end

  context "with a valid first name" do
    it "has a minimum length of 2 characters" do
      expect(user.last_name.length).to be >= 2
    end

    it "has a maximum length of 30 characters" do
      expect(user.last_name.length).to be <= 30
    end
  end
end
