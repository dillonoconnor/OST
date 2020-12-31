class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(username: params[:username_or_email]) ||
           User.find_by(email: params[:username_or_email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to session[:intended_url] || root_url, 
                  notice: "Signed In!"
      session[:intended_url] = nil
    else
      flash.now[:alert] = "Invalid username or password."
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    session[:spotify_user] = nil
    redirect_to root_url, notice: "Signed Out!"
  end
end
