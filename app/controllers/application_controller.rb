class ApplicationController < ActionController::Base
  before_action :set_search
  helper_method :current_user, :logged_in?, :date_with_slash, :format_event_time,
                :nil_check_for_latlng, :get_profile_image, :count_event_members,
                :event_capacity_is_over?, :select_target_event

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

  # return 'MM/dd'
  def date_with_slash(datetime)
    zero_padding(datetime.month) + '/' +
      zero_padding(datetime.day) + '（' +
      %w[日 月 火 水 木 金 土][datetime.wday] + '）'
  end

  # return 'HH:mm ~ HH:mm
  def format_event_time(start_at, end_at)
    zero_padding(start_at.hour) + ':' +
      zero_padding(start_at.min) + ' ~ ' +
      zero_padding(end_at.hour) + ':' +
      zero_padding(end_at.min)
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
      'Gravatar.png'
    end
  end

  # count member who join the event
  def count_event_members(event)
    EventMember.where(event_id: event.id, organizer: false).count
  end

  # if event_member is greater than event_capacity → true
  def event_capacity_is_over?(event)
    count_event_members(event) == event.event_capacity
  end

  def select_target_event(target_event)
    target_event.event
  end

  private

  # ヘッダーに検索機能を載せる為にここでransackを仕掛ける
  def set_search
    @search = Event.all.order(created_at: :desc).ransack(params[:q])
    @search_events = @search.result(distinct: true).page(params[:page]).per(5)
  end

  # zero_padding for month or day
  def zero_padding(number)
    format('%02d', number)
  end
end
