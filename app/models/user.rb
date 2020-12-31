class User < ApplicationRecord
  has_secure_password
  validates :email, :username, presence: true, 
            uniqueness: { case_sensitive: false }
  validates :email, format: { with: /\S+@\S+/ }
  validates :username, length: { minimum: 3 }, 
            format: { with: /\A[A-Z0-9]+\z/i }
  has_many :follows, dependent: :destroy
end
