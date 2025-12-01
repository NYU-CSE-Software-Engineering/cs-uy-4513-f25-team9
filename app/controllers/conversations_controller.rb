class ConversationsController < ApplicationController
  before_action :require_login

  def new
    @listing = Listing.find(params[:listing_id])
    @conversation = Conversation.new
  end

  def create
    @listing = Listing.find(params[:listing_id])
    initial_message = params[:conversation][:initial_message]

    # Validate that initial message is present
    if initial_message.blank?
      @conversation = Conversation.new
      flash.now[:alert] = "Message content cannot be empty"
      render :new, status: :unprocessable_entity
      return
    end

    @conversation = Conversation.new(
      buyer: current_user,
      seller: @listing.user,
      listing: @listing
    )

    if @conversation.save
      @conversation.messages.create!(
        content: initial_message,
        user: current_user
      )
      redirect_to @conversation, notice: "Message sent successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @conversation = Conversation.find(params[:id])
  end
end