# spec/factories.rb

FactoryBot.define do
  factory :product do
    name { Faker::Commerce.product_name }
    price { Faker::Commerce.price(range: 0..100.0, as_string: true) }
    product_type { [:good, :digital_service, :onsite_service].sample }  # Randomly selects one of the product types
  end

  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    user_type { [:individual, :company].sample }  # Randomly selects either individual or company
    country { Faker::Address.country }
  end
end
