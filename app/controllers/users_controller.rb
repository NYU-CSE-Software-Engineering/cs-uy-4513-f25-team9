class UsersController < ApplicationController
  # Only require moderator for administrative actions (index/destroy).
  before_action :require_moderator, only: [:index, :destroy]
  before_action :set_user, only: [:destroy]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, notice: "Welcome! You have signed up successfully."
    else
      flash.now[:alert] = @user.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.nil?
      flash[:error] = "User does not exist"
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

  private

  def set_user
    @user = User.find_by(id: params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def require_moderator
    unless current_user&.moderator?
      redirect_to root_path, alert: "You don't have permission to access this page"
    end
  end
end
