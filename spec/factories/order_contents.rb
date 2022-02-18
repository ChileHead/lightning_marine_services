FactoryBot.define do
  factory :order_content do
    association :order, factory: [:order]
    box { rand(0..15) }
    crate { rand(0..10) }
    pallet { rand(0..15) }
    # other { rand_other_amount }
    # other_description { rand_other_desc }
    # order_id { association :order }
  end
end
