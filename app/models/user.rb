class User < ApplicationRecord
  # Validations
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email format" }
  validates :user_type, presence: true
  validates :country, presence: true

  # Enum for user_type
  enum user_type: { individual: 0, company: 1 }
end
