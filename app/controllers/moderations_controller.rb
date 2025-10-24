class ModerationsController < ApplicationController
  # Permission verification: Only Moderators can access all actions
  before_action :authenticate_moderator!

  # Renders the list of reported products pending review
  def reported_listings
    # Queries unprocessed reports, associates with product information, and excludes deleted products
    @reported_listings = Flag.where(processed: false)
                             .joins(:listing)
                             .where(listings: { is_deleted: false })
                             .select('listings.id, listings.name, flags.report_reason')
  end

  # Handles deletion of fraudulent products
  def confirm_remove
    @listing = Listing.find_by(id: params[:listing_id], is_deleted: false)
    if @listing
      # Marks the product as deleted
      @listing.update(is_deleted: true)
      # Marks the report as processed
      Flag.where(listing_id: @listing.id).update(processed: true)
      redirect_to moderations_delete_confirmation_path
    else
      # Product does not exist or has been deleted; displays error
      flash[:error] = "This product no longer exists"
      redirect_to moderations_reported_listings_path
    end
  end

  private
  # Verifies if the current user is a Moderator
  def authenticate_moderator!
    unless current_user.roles.exists?(name: 'moderator')
      redirect_to moderations_access_denied_path
    end
  end

  def api_remove_listing
    # Only allow internal modules to call via API; verify request header (example)
    if request.headers['X-Thryft-Internal-API'] != ENV['INTERNAL_API_KEY']
      render json: { error: 'No API access permission' }, status: :forbidden
      return
    end

    @listing = Listing.find_by(id: params[:listing_id], is_deleted: false)
    if @listing
      @listing.update(is_deleted: true)
      Flag.where(listing_id: @listing.id).update(processed: true)
      render json: { message: 'Product deleted successfully' }, status: :ok
    else
      render json: { error: 'Product does not exist' }, status: :not_found
    end
  end

end