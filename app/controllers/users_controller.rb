class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user, notice: "User created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      if user_params[:password].present?
        @user.update_column(:last_password_change, Time.current)
      end
      redirect_to @user, notice: "User updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path, notice: "User deleted successfully!"
  end

  def toggle_status
    @user = User.find(params[:id])
    new_status = @user.enabled? ? "disabled" : "enabled"
    @user.update_column(:status, new_status)
    redirect_to users_path, notice: "User #{new_status} successfully!"
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :role, :status, :balance, :profile_image, :password, :password_confirmation)
  end

end