class ModerationsController < ApplicationController
  before_action :require_moderator
  before_action :set_listing, only: [:destroy_listing]
  before_action :set_user, only: [:destroy_user, :remove_moderator]
  before_action :require_admin, only: [:remove_moderator]

  def user_list
    @users = User.all
  end

  def reported_listings
    @reported_listings = fetch_reported_listings
  end

  def destroy_listing
    return handle_listing_not_found if @listing.nil?

    remove_listing_successfully
  end

  def destroy_user
    if @user.nil?
      flash[:error] = "User does not exist"
      redirect_to moderations_path
      return
    end

    if @user.id == current_user.id
      flash[:error] = "You cannot delete yourself"
      redirect_to moderations_path
      return
    end

    unless current_user.can_delete_user?(@user)
      flash[:error] = "You don't have permission to delete User with ID #{params[:id]}"
      redirect_to moderations_path
      return
    end

    user_name = @user.name
    user_id = @user.id
    @user.destroy
    flash[:notice] = "User #{user_name} with ID #{user_id} has been deleted"
    redirect_to moderations_path
  end

  def remove_moderator
    if @user.nil?
      flash[:error] = "User does not exist"
      redirect_to moderations_path
      return
    end

    unless @user.moderator?
      flash[:error] = "User #{@user.name} is not a moderator"
      redirect_to moderations_path
      return
    end

    if @user.admin?
      flash[:error] = "Cannot remove admin privileges through this action"
      redirect_to moderations_path
      return
    end

    @user.update(is_moderator: false)
    flash[:notice] = "Moderator privileges removed from #{@user.name}"
    redirect_to moderations_path
  end

  private

  def set_listing
    @listing = Listing.find_by(id: params[:id])
  end

  def set_user
    @user = User.find_by(id: params[:id])
  end

  def require_moderator
    unless current_user&.moderator?
      redirect_to root_path, alert: "You don't have permission to access this page"
    end
  end

  def require_admin
    unless current_user&.admin?
      flash[:error] = "Only admins can perform this action"
      redirect_to moderations_path
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
    # @listing.destroy
    if @listing.destroy
      flash[:notice] = "Listing #{listing_title} with ID #{listing_id} has been removed"
    else
      flash[:error] = "Failed to remove listing #{listing_title} with ID #{listing_id}"
    end
    redirect_to reported_listings_path
  end
end

