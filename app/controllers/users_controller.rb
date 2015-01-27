class UsersController < ApplicationController
  before_filter :require_user, only: :show
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params) # Not the final implementation!
    result = UserSignup.new(@user).sign_up(params[:stripeToken], params[:invitation_token])
    
    if result.successful?
      log_in @user
      flash[:success] = "Welcome to MyFlix!"
      redirect_to home_path
    else
      flash[:error] = result.error_message
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def new_with_invitation_token
    invitation = Invitation.where(token: params[:token]).first
    if invitation
      @user = User.new(email: invitation.recipient_email)
      @invitation_token = invitation.token
      render :new
    else
      redirect_to expired_token_path
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end
