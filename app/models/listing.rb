# app/models/listing.rb

class Listing < ApplicationRecord
  belongs_to :user
  has_many :reports  

end