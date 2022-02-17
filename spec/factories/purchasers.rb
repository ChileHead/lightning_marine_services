FactoryBot.define do
  factory :purchaser do
    name { Faker::Company.unique.name }
  end
end
