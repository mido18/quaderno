# spec/models/product_spec.rb

require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      product = FactoryBot.build(:product)
      expect(product).to be_valid
    end

    it 'is not valid without a name' do
      product = FactoryBot.build(:product, name: nil)
      expect(product).to_not be_valid
    end

    it 'is not valid without a price' do
      product = FactoryBot.build(:product, price: nil)
      expect(product).to_not be_valid
    end

    it 'is not valid with a negative price' do
      product = FactoryBot.build(:product, price: -10.00)
      expect(product).to_not be_valid
    end

    it 'is not valid without a product_type' do
      product = Product.new(name: 'Cooking Class', product_type: nil)
      expect(product).to_not be_valid
    end

    it 'is not valid with a duplicate name' do
      FactoryBot.create(:product, name: 'Unique Product')
      product = FactoryBot.build(:product, name: 'Unique Product')
      expect(product).to_not be_valid
    end
  end

  describe 'enums' do
    it 'defines product_type enum' do
      expect(Product.product_types).to eq({ 'good' => 0, 'digital_service' => 1, 'onsite_service' => 2 })
    end

    it 'returns good for product_type good' do
      product = Product.new(product_type: :good)
      expect(product.product_type).to eq('good')
    end

    it 'returns digital_service for product_type digital_service' do
      product = Product.new(product_type: :digital_service)
      expect(product.product_type).to eq('digital_service')
    end

    it 'returns onsite_service for product_type onsite_service' do
      product = Product.new(product_type: :onsite_service)
      expect(product.product_type).to eq('onsite_service')
    end
  end
end
