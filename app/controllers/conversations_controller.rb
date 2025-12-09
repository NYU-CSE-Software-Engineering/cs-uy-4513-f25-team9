class ConversationsController < ApplicationController
  before_action :require_login

  def index
    # Get all conversations where current user is either buyer or seller
    @conversations = Conversation.where(buyer: current_user)
                                 .or(Conversation.where(seller: current_user))
                                 .includes(:listing, :buyer, :seller, :messages)
                                 .order(updated_at: :desc)
  end

  def new
    @listing = Listing.find(params[:listing_id])
    @conversation = Conversation.new
  end

  def create
    @listing = Listing.find(params[:listing_id])

    # Prevent users from messaging themselves
    if current_user == @listing.user
      redirect_to @listing, alert: "You cannot message yourself about your own listing"
      return
    end

    # Check for existing conversation
    existing_conversation = Conversation.find_by(
      buyer: current_user,
      seller: @listing.user,
      listing: @listing
    )

    if existing_conversation
      redirect_to existing_conversation, notice: "You already have a conversation about this listing"
      return
    end

    # Check if params[:conversation] exists
    conversation_params = params[:conversation] || {}
    initial_message = conversation_params[:initial_message]

    # Validate that initial message is present
    if initial_message.blank?
      @conversation = Conversation.new
      flash.now[:alert] = "Message content cannot be empty"
      render :new, status: :unprocessable_content
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
      render :new, status: :unprocessable_content
    end
  end

  def show
    @conversation = Conversation.find(params[:id])
  end
end