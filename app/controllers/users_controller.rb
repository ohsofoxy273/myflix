class UsersController < ApplicationController
  before_filter :require_user, only: :show
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params) # Not the final implementation!
    if @user.save
      Stripe.api_key = ENV['STRIPE_TEST_SECRET_KEY']
      Stripe::Charge.create(  :amount => 999,
                              :currency => "usd",
                              :card => params[:stripeToken],
                              :description => "Sign up charge for #{@user.email}"
                             )
      #StripeWrapper::Charge.create()
      handle_invitation
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

    def handle_invitation
      if params[:invitation_token].present?
        invitation = Invitation.where(token: params[:invitation_token]).first
        @user.follow(invitation.inviter)
        invitation.inviter.follow(@user)
        invitation.update_column(:token, nil)
      end
    end

end
