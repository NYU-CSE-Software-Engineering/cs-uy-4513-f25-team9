class SwipesController < ApplicationController
  before_action :require_login

  def create
    listing = Listing.find_by(id: params[:listing_id])
    return render plain: "Listing not found", status: :not_found unless listing

    state = params[:state].to_s
    unless Interest::STATES.include?(state)
      return render plain: "Invalid state", status: :unprocessable_content
    end

    interest = Interest.find_or_initialize_by(buyer: current_user, listing: listing)
    interest.state = state

    if interest.save
      redirect_to "/feed", notice: "Saved as #{state}"
    else
      render plain: interest.errors.full_messages.to_sentence, status: :unprocessable_content
    end
  end
end
