require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:product) }
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      transaction = FactoryBot.build(:transaction)
      expect(transaction).to be_valid
    end

    it 'is not valid without a user' do
      transaction = FactoryBot.build(:transaction, user: nil)
      expect(transaction).to_not be_valid
    end

    it 'is not valid without a product' do
      transaction = FactoryBot.build(:transaction, product: nil)
      expect(transaction).to_not be_valid
    end

    it 'is not valid without a transaction_type' do
      transaction = FactoryBot.build(:transaction, transaction_type: nil)
      expect(transaction).to_not be_valid
    end

    it 'is not valid without a transaction_date' do
      transaction = FactoryBot.build(:transaction, transaction_date: nil)
      expect(transaction).to_not be_valid
    end

    it 'is not valid with a negative tax_applied' do
      transaction = FactoryBot.build(:transaction, tax_applied: -10.00)
      expect(transaction).to_not be_valid
    end

    it 'is not valid without a status' do
      transaction = FactoryBot.build(:transaction, status: nil)
      expect(transaction).to_not be_valid
    end
  end

  describe 'enums' do
    it 'defines transaction_type enum' do
      expect(Transaction.transaction_types).to eq({ 'good' => 0, 'digital_service' => 1, 'onsite_service' => 2 })
    end

    it 'returns good for transaction_type 0' do
      transaction = Transaction.new(transaction_type: :good)
      expect(transaction.transaction_type).to eq('good')
    end

    it 'returns digital_service for transaction_type 1' do
      transaction = Transaction.new(transaction_type: :digital_service)
      expect(transaction.transaction_type).to eq('digital_service')
    end

    it 'returns onsite_service for transaction_type 2' do
      transaction = Transaction.new(transaction_type: :onsite_service)
      expect(transaction.transaction_type).to eq('onsite_service')
    end


    it 'defines status enum' do
      expect(Transaction.statuses).to eq({ 'completed' => 0, 'pending' => 1, 'refunded' => 2, "reverse_charge" => 3, "export" => 4 })
    end

    it 'returns completed for status 0' do
      transaction = Transaction.new(status: :completed)
      expect(transaction.status).to eq('completed')
    end

    it 'returns pending for status 1' do
      transaction = Transaction.new(status: :pending)
      expect(transaction.status).to eq('pending')
    end

    it 'returns refunded for status 2' do
      transaction = Transaction.new(status: :refunded)
      expect(transaction.status).to eq('refunded')
    end
  end


  describe '#process_sale' do
    let(:transaction) { FactoryBot.build(:transaction) }

    context 'when the product is a good' do
      before do
        transaction.product = FactoryBot.build(:product, product_type: 'good')
      end

      it 'uses the PhysicalProductTaxStrategy' do
        strategy = instance_double(PhysicalProductTaxStrategy)
        allow(PhysicalProductTaxStrategy).to receive(:new).and_return(strategy)
        expect(strategy).to receive(:calculate_tax).with(transaction)
        transaction.process_sale
      end
    end

    context 'when the product is a digital service' do
      before do
        transaction.product = FactoryBot.build(:product, product_type: 'digital_service')
      end

      it 'uses the DigitalServiceTaxStrategy' do
        strategy = instance_double(DigitalServiceTaxStrategy)
        allow(DigitalServiceTaxStrategy).to receive(:new).and_return(strategy)
        expect(strategy).to receive(:calculate_tax).with(transaction)
        transaction.process_sale
      end
    end

    context 'when the product is an onsite service' do
      before do
        transaction.product = FactoryBot.build(:product, product_type: 'onsite_service')
      end

      it 'uses the OnsiteServiceTaxStrategy' do
        strategy = instance_double(OnsiteServiceTaxStrategy)
        allow(OnsiteServiceTaxStrategy).to receive(:new).and_return(strategy)
        expect(strategy).to receive(:calculate_tax).with(transaction)
        transaction.process_sale
      end
    end
  end
end
