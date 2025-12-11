class ListingsController < ApplicationController
  before_action :require_login, only: [:new, :create, :edit, :update, :destroy, :seller_home]
  before_action :set_listing, only: [:show, :edit, :update, :destroy]
  before_action :authorize_owner, only: [:edit, :update, :destroy]

  def index
    @listings = Listing.all

    # Category filter
    if params[:category].present?
      @listings = @listings.where(category: params[:category])
    end

    # Price filters
    if params[:min_price].present?
      @listings = @listings.where("price >= ?", params[:min_price].to_f)
    end

    if params[:max_price].present?
      @listings = @listings.where("price <= ?", params[:max_price].to_f)
    end

    # Search filter
    if params[:search].present?
      query = "%#{params[:search].downcase}%"
      @listings = @listings.where(
        "LOWER(title) LIKE ? OR LOWER(description) LIKE ?",
        query, query
      )
    end

    # Sorting
    case params[:sort]
    when "price_asc"
      @listings = @listings.order(price: :asc)
    when "price_desc"
      @listings = @listings.order(price: :desc)
    else
      @listings = @listings.order(created_at: :desc)
    end

    # For the dropdown
    @categories = Listing.distinct.pluck(:category).compact
  end

  def liked
    if current_user
      # Show only listings the current user has shown interest in
      @listings = Listing.joins(:interests)
                         .where(interests: { buyer_id: current_user.id })
                         .distinct
    else
      @listings = Listing.none
    end
    render :index
  end

  def seller_home
    @listings = current_user.listings.order(created_at: :desc)
  end

  def show
  end

  def new
    @listing = Listing.new
  end

  def create
    @listing = current_user.listings.new(listing_params)
    if @listing.save
      redirect_to seller_home_path, notice: "Listing created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @listing.update(listing_params)
      redirect_to seller_home_path, notice: "Listing updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @listing.destroy
      redirect_to seller_home_path, notice: "Listing deleted successfully"
    else
      redirect_to seller_home_path, alert: "Failed to delete listing"
    end
  end

  private

  def build_filtered_listings
    listings = Listing.all
    listings = listings.by_category(params[:category]) if params[:category].present?
    listings = listings.by_price_range(
      min_price: params[:min_price],
      max_price: params[:max_price]
    )
    listings = listings.by_search(params[:q]) if params[:q].present?
    listings
  end

  def set_listing
    @listing = Listing.find(params[:id])
  end

  def listing_params
    params.require(:listing).permit(:title, :description, :price, :category, :image)
  end

  def authorize_owner
    unless @listing.user == current_user
      redirect_to listings_path, alert: "You are not authorized to edit this listing"
    end
  end
end
