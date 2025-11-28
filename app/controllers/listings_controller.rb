class ListingsController < ApplicationController
  before_action :require_login, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_listing, only: [:show, :edit, :update, :destroy]
  before_action :authorize_owner, only: [:edit, :update, :destroy]

  def index
    @listings = Listing.all
  end

  def show
  end

  def new
    @listing = Listing.new
  end

  def create
    @listing = current_user.listings.new(listing_params)
    if @listing.save
      redirect_to @listing, notice: "Listing created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @listing.update(listing_params)
      redirect_to @listing, notice: "Listing updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @listing.destroy
      redirect_to listings_path, notice: "Listing deleted successfully"
    else
      redirect_to listings_path, alert: "Failed to delete listing"
    end
  end

  private

  def set_listing
    @listing = Listing.find(params[:id])
  end

  def listing_params
    params.require(:listing).permit(:title, :description, :price)
  end

  def authorize_owner
    unless @listing.user == current_user
      redirect_to listings_path, alert: "You are not authorized to edit this listing"
    end
  end
end
