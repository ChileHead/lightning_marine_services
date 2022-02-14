require 'rails_helper'

RSpec.describe User, type: :model do
  let(:first_name) { Faker::Name.unique.first_name }
  let(:last_name) { Faker::Name.unique.last_name }
  let(:phone_number) { Faker::PhoneNumber.cell_phone }
  let(:email) { Faker::Internet.email }
  let(:username) { Faker::Internet.username }
  let(:password) { '123456' }

  let(:user) {
    build(
      :user,
        first_name: first_name,
        last_name: last_name,
        phone_number: phone_number,
        email: email,
        username: username,
        password: password,
    )
  }

  before do
    user.skip_confirmation!
    user.save
  end

  after do
    user.destroy
  end

  it "is a valid user" do
    expect(user).to be_valid
  end
end
