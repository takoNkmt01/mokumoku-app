class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_same_user(user)
    return unless current_user != user && !current_user&.admin?
    
    flash[:danger] = '不正なアクセスです'
    redirect_to root_path
  end

  def require_user
    return if logged_in?

    flash[:danger] = '会員様のみ利用できます'
    redirect_to root_path
  end
end
