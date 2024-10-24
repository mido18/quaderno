# spec/models/user_spec.rb

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      user = FactoryBot.build(:user)
      expect(user).to be_valid
    end

    it 'is not valid without a name' do
      user = FactoryBot.build(:user, name: nil)
      expect(user).to_not be_valid
    end

    it 'is not valid without an email' do
      user = FactoryBot.build(:user, email: nil)
      expect(user).to_not be_valid
    end

    it 'is not valid without a user_type' do
      user = FactoryBot.build(:user, user_type: nil)
      expect(user).to_not be_valid
    end

    it 'is not valid without a country' do
      user = FactoryBot.build(:user, country: nil)
      expect(user).to_not be_valid
    end

    it 'is not valid with a duplicate email' do
      FactoryBot.create(:user,  email: 'john@example.com')
      user = User.new(name: 'John Doe', email: 'john@example.com', user_type: :individual, country: 'Spain')
      expect(user).to_not be_valid
    end

    it 'is not valid with an invalid email format' do
      user = User.new(name: 'John Doe', email: 'invalid_email', user_type: :individual, country: 'Spain')
      expect(user).to_not be_valid
      expect(user.errors[:email]).to include("must be a valid email format")
    end
  end

  describe 'enums' do
    it 'defines user_type enum' do
      expect(User.user_types).to eq({ "individual" => 0, "company" => 1 })
    end

    it 'returns individual for user_type 0' do
      user = User.new(user_type: :individual)
      expect(user.user_type).to eq('individual')
    end

    it 'returns company for user_type 1' do
      user = User.new(user_type: :company)
      expect(user.user_type).to eq('company')
    end
  end
end
