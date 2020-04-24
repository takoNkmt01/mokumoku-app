class ApplicationController < ActionController::Base
  helper_method :date_with_slash, :format_event_time

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

  private

  # zero_padding for month or day
  def zero_padding(number)
    format('%02d', number)
  end
end
