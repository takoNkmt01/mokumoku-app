class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?, :event_capacity_is_over?,
                :count_event_members

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  # if event_member is greater than event_capacity → true
  def event_capacity_is_over?(event)
    count_event_members(event) == event.event_capacity
  end

  # count member who join the event except organizer
  def count_event_members(event)
    EventMember.where(event_id: event.id, organizer: false).count
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
