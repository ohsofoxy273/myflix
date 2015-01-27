class SessionsController < ApplicationController
  def new
    redirect_to home_path if logged_in?
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.active?
        log_in user
        redirect_to home_path, notice: "You are signed in!"
      else
        render :new, notice: "Your account has been suspended, please contact customer service."
      end
    else
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_path,  notice: "You are signed out."
  end

end
