# spec/services/onsite_service_tax_strategy_spec.rb
require 'rails_helper'

RSpec.describe OnsiteServiceTaxStrategy do
  let(:strategy) { described_class.new }
  let(:transaction) { instance_double("Transaction") }
  let(:tax_rate) { instance_double("TaxRate") }

  before do
    allow(transaction).to receive(:save)
  end

  describe '#calculate_tax' do
    context 'when applying VAT for onsite service' do
      before do
        allow(TaxRate).to receive(:find_by).with(country: "Spain", product_type: "onsite_service").and_return(tax_rate)
      end

      it 'sets tax_applied and status correctly' do
        allow(tax_rate).to receive(:vat_rate).and_return(21.0) # Example VAT rate

        expect(transaction).to receive(:tax_applied=).with(21.0)
        expect(transaction).to receive(:status=).with("completed")

        strategy.calculate_tax(transaction)
      end

      it 'saves the transaction' do
        allow(tax_rate).to receive(:vat_rate).and_return(21.0)

        expect(transaction).to receive(:tax_applied=).with(21.0)
        expect(transaction).to receive(:status=).with("completed")
        expect(transaction).to receive(:save)

        strategy.calculate_tax(transaction)
      end
    end
  end
end

