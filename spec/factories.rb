# spec/factories.rb

FactoryBot.define do
  factory :tax_rate do
    country { Faker::Address.country }  # Generates a random country name
    product_type { [:good, :digital_service, :onsite_service].sample }  # Randomly selects one of the product types
    vat_rate { Faker::Number.decimal(l_digits: 2, r_digits: 2) }  # Generates a random VAT rate with two decimal places
  end

  factory :transaction do
    association :user  # Automatically creates a user using the user factory
    association :product  # Automatically creates a product using the product factory
    transaction_type { [ :good, :digital_service, :onsite_service ].sample }  # Randomly selects one of the transaction types
    tax_applied { Faker::Commerce.price(range: 0..20.0, as_string: true) }
    transaction_date { Time.current }
    status { [ :completed, :pending, :refunded ].sample }  # Randomly selects one of the status types
  end

  factory :product do
    name { Faker::Commerce.product_name }
    price { Faker::Commerce.price(range: 0..100.0, as_string: true) }
    product_type { [ :good, :digital_service, :onsite_service ].sample }  # Randomly selects one of the product types
  end

  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    user_type { [ :individual, :company ].sample }  # Randomly selects either individual or company
    country { Faker::Address.country }
  end
end
