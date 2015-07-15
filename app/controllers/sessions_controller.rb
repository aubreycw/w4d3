class SessionsController < ApplicationController
  def new
    @user = User.new
    render :new
  end

  def create
    @user = current_user
    if @user
      session[:session_token] = @user.session_token
      redirect_to cats_url
    else
      flash.now[:errors] ||= []
      flash.now[:errors] << "Invalid login credentials"
      render :new
    end
  end

  def destroy
    session[:session_token] = nil
    current_user.reset_session_token!
    flash.now[:status] ||= []
    flash.now[:status] << "Successful logout!"
    redirect_to cats_url
  end
end
