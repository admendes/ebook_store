class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by(email: params[:email].downcase)

    if user && user.authenticate(params[:password])
      if user.enabled?
        session[:user_id] = user.id
        redirect_to session.delete(:return_to) || root_path, notice: "Welcome back, #{user.name}!"
      else
        render :new, alert: "Your account is disabled."
      end
    else
      flash.now[:alert] = "Invalid email or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to login_path, notice: "Logged out successfully."
  end
end