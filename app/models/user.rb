class User < ApplicationRecord
  has_many :purchases, foreign_key: :buyer_id
  has_many :reports
end
