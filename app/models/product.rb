class Product < ApplicationRecord
    # Validations
    validates :name, presence: true, uniqueness: true
    validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :product_type, presence: true

    # Enum for product_type
    enum product_type: { good: "good", digital_service: "digital_service", onsite_service: "onsite_service" }
end
