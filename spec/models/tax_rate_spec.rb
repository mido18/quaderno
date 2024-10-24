require 'rails_helper'

RSpec.describe TaxRate, type: :model do
  it 'is valid with valid attributes' do
    tax_rate = FactoryBot.build(:tax_rate)  # Use FactoryBot to build a tax rate
    expect(tax_rate).to be_valid
  end

  it 'is not valid without a country' do
    tax_rate = FactoryBot.build(:tax_rate, country: nil)  # Use FactoryBot to build a tax rate without a country
    expect(tax_rate).to_not be_valid
  end

  it 'is not valid without a product_type' do
    tax_rate = FactoryBot.build(:tax_rate, product_type: nil)  # Use FactoryBot to build a tax rate without a product_type
    expect(tax_rate).to_not be_valid
  end

  it 'is not valid without a vat_rate' do
    tax_rate = FactoryBot.build(:tax_rate, vat_rate: nil)  # Use FactoryBot to build a tax rate without a vat_rate
    expect(tax_rate).to_not be_valid
  end

  it 'is not valid with a negative vat_rate' do
    tax_rate = FactoryBot.build(:tax_rate, vat_rate: -5.00)  # Use FactoryBot to build a tax rate with a negative vat_rate
    expect(tax_rate).to_not be_valid
  end

  it 'is not valid with a duplicate country and product_type' do
    FactoryBot.create(:tax_rate, country: 'Spain', product_type: 'good', vat_rate: 21.00)  # Create a tax rate
    tax_rate = FactoryBot.build(:tax_rate, country: 'Spain', product_type: 'good', vat_rate: 10.00)  # Attempt to create another tax rate with the same country and product_type
    expect(tax_rate).to_not be_valid
  end
end
