class UsersController < ApplicationController
  before_filter :require_user, only: :show
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params) # Not the final implementation!
    if @user.save
      AppMailer.send_welcome_email(@user).deliver
      log_in @user
      flash[:success] = "Welcome to MyFlix!"
      redirect_to home_path
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

end
