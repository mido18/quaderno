# spec/services/digital_service_tax_strategy_spec.rb
require 'rails_helper'

RSpec.describe DigitalServiceTaxStrategy do
  let(:strategy) { described_class.new }
  let(:transaction) { instance_double("Transaction") }
  let(:user) { instance_double("User") }
  let(:tax_rate) { instance_double("TaxRate") }

  before do
    allow(transaction).to receive(:user).and_return(user)
    allow(transaction).to receive(:save)
  end

  describe '#calculate_tax' do
    context 'when user is from Spain' do
      before do
        allow(user).to receive(:country).and_return("Spain")
        allow(TaxRate).to receive(:find_by).with(country: "Spain", product_type: "digital_service").and_return(tax_rate)
      end

      it 'applies VAT and sets status to completed' do
        allow(tax_rate).to receive(:vat_rate).and_return(21.0)
        expect(transaction).to receive(:tax_applied=).with(21.0)
        expect(transaction).to receive(:status=).with("completed")

        strategy.calculate_tax(transaction)
      end
    end

    context 'when user is from an EU country' do
      before do
        allow(user).to receive(:country).and_return("France")
        allow(transaction).to receive(:eu_country?).and_return(true)
      end

      context 'when user is an individual' do
        before do
          allow(user).to receive(:user_type).and_return("individual")
          allow(TaxRate).to receive(:find_by).with(country: "France", product_type: "digital_service").and_return(tax_rate)
        end

        it 'applies local VAT and sets status to completed' do
          allow(tax_rate).to receive(:vat_rate).and_return(20.0)
          expect(transaction).to receive(:tax_applied=).with(20.0)
          expect(transaction).to receive(:status=).with("completed")

          strategy.calculate_tax(transaction)
        end
      end

      context 'when user is a company' do
        before do
          allow(user).to receive(:user_type).and_return("company")
        end

        it 'marks the transaction as reverse charge' do
          expect(transaction).to receive(:status=).with("reverse_charge")
          expect(transaction).to receive(:tax_applied=).with(0)

          strategy.calculate_tax(transaction)
        end
      end
    end

    context 'when user is from a non-EU country' do
      before do
        allow(user).to receive(:country).and_return("USA")
      end

      it 'sets tax_applied to 0 and status to completed' do
        expect(transaction).to receive(:eu_country?).with("USA")
        expect(transaction).to receive(:tax_applied=).with(0)
        expect(transaction).to receive(:status=).with("completed")

        strategy.calculate_tax(transaction)
      end
    end
  end
end
