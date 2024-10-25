class Product < ApplicationRecord
    # Validations
    validates :name, presence: true, uniqueness: true
    validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :product_type, presence: true

    # Enum for product_type
    enum product_type: { good: 0, digital_service: 1, onsite_service: 2 }
end
