class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def require_user
    unless current_user
      flash[:info] = "This is reserved for members, please login or register fisrt!"
      redirect_to login_path
    end
  end
end
