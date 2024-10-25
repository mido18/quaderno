class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :product

  # Validations
  validates :transaction_type, presence: true
  validates :tax_applied, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :transaction_date, presence: true
  validates :status, presence: true

  # Enum for transaction_type
  enum transaction_type: { good: 0, digital_service: 1, onsite_service: 2 }

  # Enum for status
  enum status: { completed: 0, pending: 1, refunded: 2, reverse_charge: 3, export: 4 }

  # Method to process the sale
  def process_sale
    strategy = case product.product_type
    when "good"
                 PhysicalProductTaxStrategy.new
    when "digital_service"
                 DigitalServiceTaxStrategy.new
    when "onsite_service"
                 OnsiteServiceTaxStrategy.new
    end

    strategy.calculate_tax(self) if strategy
  end
end
