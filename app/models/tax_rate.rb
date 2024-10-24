class TaxRate < ApplicationRecord
  # Validations
  validates :country, presence: true
  validates :product_type, presence: true
  validates :vat_rate, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Enum for product_type
  enum product_type: { good: 0, digital_service: 1, onsite_service: 2 }
end
