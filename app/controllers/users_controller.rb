class UsersController < ApplicationController
  before_action :require_moderator
  before_action :set_user, only: [:destroy]

  def index
    @users = User.all
  end

  def destroy
    if @user.nil?
      flash[:error] = "User does not exist"
      redirect_to users_path
      return
    end

    unless current_user.can_delete_user?(@user)
      flash[:error] = "You don't have permission to delete User with ID #{params[:id]}"
      redirect_to users_path
      return
    end

    user_name = @user.name
    user_id = @user.id
    @user.destroy
    flash[:notice] = "User #{user_name} with ID #{user_id} has been deleted"
    redirect_to users_path
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
  end

  def require_moderator
    unless current_user&.moderator?
      redirect_to root_path, alert: "You don't have permission to access this page"
    end
  end
end
