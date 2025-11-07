class User < ApplicationRecord
  has_secure_password

  has_many :listings, dependent: :destroy
  has_many :reports, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
end