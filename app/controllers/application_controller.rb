class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?,
                :nil_check_for_latlng, :get_profile_image, :count_event_members,
                :event_capacity_is_over?, :conversion_to_event_model, :count_reply_comments,
                :select_returned_comments

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

  # execute null check for latlng
  # if value is null, return 0
  def nil_check_for_latlng(lat_or_lng)
    lat_or_lng.nil? ? 0 : lat_or_lng
  end

  # fetch profile image from active storage
  # if user uploaded image
  def get_profile_image(user_profile_image)
    if user_profile_image.attached?
      user_profile_image
    else
      'no-user.png'
    end
  end

  # count member who join the event except organizer
  def count_event_members(event)
    EventMember.where(event_id: event.id, organizer: false).count
  end

  # if event_member is greater than event_capacity → true
  def event_capacity_is_over?(event)
    count_event_members(event) == event.event_capacity
  end

  # EventMember model → Event model
  def conversion_to_event_model(event_member_model)
    events_list = event_member_model.map(&:event)
    events_list.sort { |a, b| b[:start_at] <=> a[:start_at] }
  end

  # counts Reply to Comment
  def count_reply_comments(target_comment)
    Comment.where(reply_to: target_comment.id).count
  end

  # select returned comments
  def select_returned_comments(target_comment)
    Comment.where(reply_to: target_comment.id)
  end
end
