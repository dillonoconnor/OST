class UsersController < ApplicationController

  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    @user = User.all
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Account Created!"
    else
      flash.now[:alert] = "There are errors in the form."
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: "Profile updated!"
    else
      flash.now[:alert] = "There are errors in the form."
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to root_url
  end
  
  private

    def user_params
      params.require(:user).permit(:email, :username, :password,
                                   :password_confirmation)
    end

    def set_user
      @user = User.find(params[:id])
    end
end
