# spec/factories.rb

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    user_type { [:individual, :company].sample }  # Randomly selects either individual or company
    country { Faker::Address.country }
  end
end
