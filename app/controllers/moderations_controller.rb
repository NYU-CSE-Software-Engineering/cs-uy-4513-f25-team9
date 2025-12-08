class ModerationsController < ApplicationController
  before_action :require_moderator
  before_action :set_listing, only: [:destroy]

  def reported_listings
    @reported_listings = fetch_reported_listings
  end

  def destroy
    return handle_listing_not_found if @listing.nil?

    remove_listing_successfully
  end

  private

  def set_listing
    @listing = Listing.find_by(id: params[:id])
  end

  def require_moderator
    unless current_user&.moderator?
      redirect_to root_path, alert: "You don't have permission to access this page"
    end
  end

  def fetch_reported_listings
    # Get all listings that have reports
    reported_listing_ids = Report.select(:listing_id).distinct.pluck(:listing_id)
    Listing.where(id: reported_listing_ids).includes(:reports, :user).order(created_at: :desc)
  end

  def handle_listing_not_found
    flash[:error] = "Listing does not exist"
    redirect_to reported_listings_path
  end

  def remove_listing_successfully
    listing_title = @listing.title
    listing_id = @listing.id
    @listing.destroy
    flash[:notice] = "Listing #{listing_title} with ID #{listing_id} has been removed"
    redirect_to reported_listings_path
  end
end

