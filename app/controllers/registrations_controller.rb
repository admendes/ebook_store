class RegistrationsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(registration_params)
    @user.last_password_change = Time.current

    if @user.save
      session[:user_id] = @user.id
      # Send welcome email
      UserMailer.welcome_email(@user).deliver_now
      redirect_to root_path, notice: "Welcome to Ebook Store, #{@user.name}!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def registration_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
  end
end