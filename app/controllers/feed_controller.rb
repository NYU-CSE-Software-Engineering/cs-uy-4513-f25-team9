class FeedController < ApplicationController
  before_action :require_login

  def index
    listings = Listing.all
    listings = listings.not_owned_by(current_user)
    listings = listings.not_purchased
    listings = listings.by_category(params[:category]) if params[:category].present?
    listings = listings.by_price_range(min_price: params[:min_price], max_price: params[:max_price])
    listings = listings.by_search(params[:q]) if params[:q].present?

    swiped_ids = Interest.where(buyer: current_user).select(:listing_id)
    listings = listings.excluding_ids(swiped_ids)

    @listing = listings.order(created_at: :desc).first
  end
end
