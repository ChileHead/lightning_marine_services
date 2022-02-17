FactoryBot.define do
  factory :vendor do
    name { Faker::Company.unique.name }
  end
end
