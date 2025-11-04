class User < ApplicationRecord
  has_many :purchases, foreign_key: :buyer_id
end
