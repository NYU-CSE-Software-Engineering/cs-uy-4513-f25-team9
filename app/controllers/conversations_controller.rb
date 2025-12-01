class ConversationsController < ApplicationController
  before_action :require_login

  def new
    @listing = Listing.find(params[:listing_id])
    @conversation = Conversation.new
  end

  def create
    @listing = Listing.find(params[:listing_id])
    @conversation = Conversation.new(
      buyer: current_user,
      seller: @listing.user,
      listing: @listing
    )

    if @conversation.save
      redirect_to @conversation, notice: "Conversation started successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @conversation = Conversation.find(params[:id])
  end
end