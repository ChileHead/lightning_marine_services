FactoryBot.define do
  factory :order do
    courrier { ['Fedex', 'UPS', 'USPS', 'DHL'].sample }
    association :purchaser, factory: [:purchaser]
    association :vendor, factory: [:vendor]
    association :order_content, factory: [:order_content]
  end
end
