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

  before_validation :set_default_status

  after_create :process_sale

  # Method to set default status before validation
  def set_default_status
    self.status ||= "pending" # Set default status to 'pending' if not already set
  end

  # Method to process the sale
  def process_sale
    puts "Processing sale for transaction ID: #{id}" # Debugging output

    strategy = case product.product_type
    when "good"
                 PhysicalProductTaxStrategy.new
    when "digital_service"
                 DigitalServiceTaxStrategy.new
    when "onsite_service"
                 OnsiteServiceTaxStrategy.new
    end

    if strategy
      strategy.calculate_tax(self)
      puts "Tax calculated for transaction ID: #{id}" # Debugging output
    else
      puts "No strategy found for product type: #{product.product_type}" # Debugging output
    end
  end
end
