class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  def current_user
    @current_user ||= User.find_by_session_token(session[:session_token])
  end

  def login_user!(user)
    session[:session_token] = user.session_token
  end

  def require_not_logged_in
    redirect_to cats_url unless current_user.nil?
  end

  def require_cat_owner
    cat_owner = Cat.find(params[:id]).user
    unless current_user && current_user.id == cat_owner.id
      flash[:errors] = ["Not your cat!"]
      redirect_to cats_url
    end
  end
end
