class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_user
    return if logged_in?

    flash[:danger] = '会員様のみ利用できます'
    redirect_to root_path
  end

  # EventMember model → Event model
  def conversion_to_event_model(event_member_model)
    events_list = event_member_model.map(&:event)
    events_list.sort { |a, b| b[:start_at] <=> a[:start_at] }
  end
end
