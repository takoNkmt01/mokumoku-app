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

  # ['aaaa', 'bbbbb', 'cc'] -> 'aaaa,bbbbb,cc'
  def array_to_string_with_dot(array_list)
    string_with_dot = ''
    i = 0
    while i < array_list.length
      string_with_dot += array_list[i]
      string_with_dot += ', ' if i != (array_list.length - 1)
      i += 1
    end
    string_with_dot
  end
end
