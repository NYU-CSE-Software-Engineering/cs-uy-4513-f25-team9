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
  # User review-related actions
  def reported_users
    # Get unprocessed user reports
    @reported_users = UserReport.where(status: 'unprocessed')
                               .joins(:reported_user)
                               .where(users: { status: 'active' })
                               .select('users.id, users.email, users.name, user_reports.reason, user_reports.id as report_id')
  end

  # Handle user banning
  def ban_user
    @user = User.find_by(id: params[:user_id], status: 'active')
    @report = UserReport.find_by(id: params[:report_id])
    
    if @user && @report
      # Update user status
      @user.update(
        status: 'banned',
        ban_reason: params[:ban_reason],
        banned_until: params[:is_permanent] == 'true' ? nil : params[:ban_duration].to_i.days.from_now
      )
      
      # Mark report as processed
      @report.update(status: 'processed')
      
      # Record moderation log
      ModerationLog.create(
        moderator: current_user,
        target_user: @user,
        operation_type: 'user_ban',
        operation_notes: "Banned #{params[:is_permanent] == 'true' ? 'permanently' : "for #{params[:ban_duration]} days"}. Reason: #{params[:ban_reason]}"
      )
      
      flash[:success] = "User has been successfully banned"
      redirect_to moderations_reported_users_path
    else
      flash[:error] = "User not found or already banned"
      redirect_to moderations_reported_users_path
    end
  end

  # View user review history
  def user_audit_history
    @user = User.find(params[:user_id])
    @ban_logs = ModerationLog.where(target_user: @user, operation_type: 'user_ban')
  end
  # User ban API
  def api_ban_user
    # Verify internal API key
    unless request.headers['X-Thryft-Internal-API'] == ENV['INTERNAL_API_KEY']
      render json: { error: 'No API access permission' }, status: :forbidden
      return
    end

    user = User.find_by(id: params[:user_id], status: 'active')
    if user
      user.update(
        status: 'banned',
        ban_reason: params[:ban_reason],
        banned_until: params[:is_permanent] ? nil : params[:ban_duration].to_i.days.from_now
      )
      
      # Record log
      ModerationLog.create(
        moderator: User.find_by(role: 'moderator'), # Adjust according to actual situation
        target_user: user,
        operation_type: 'user_ban',
        operation_notes: params[:ban_reason]
      )
      
      render json: { message: 'User banned successfully' }, status: :ok
    else
      render json: { error: 'User not found or already banned' }, status: :not_found
    end
  end
end


end