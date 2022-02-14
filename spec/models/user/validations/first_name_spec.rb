require 'rails_helper'

RSpec.describe User, type: :model do
  context "a valid first name" do
    let(:first_name) { 'ValidFirstName' }

    let(:valid_user) {
      build(
        :user,
          first_name: first_name,
      )
    }

    before do
      valid_user.skip_confirmation!
      valid_user.save
    end

    after do
      valid_user.destroy
    end

    it "has a minimum length of 2 characters" do
      expect(valid_user.first_name.length).to be >= 2
    end

    it "has a maximum length of 30 characters" do
      expect(valid_user.first_name.length).to be <= 30
    end
  end

  context "an invalid first name" do
    let(:user) {
      build(
        :user
      )
    }

    it "has less than 2 characters" do
      user.first_name = 'x'
      expect(user).to_not be_valid
    end

    it "has more than 30 characters" do
      user.first_name = 'x'*31
      expect(user).to_not be_valid
    end
  end
end
