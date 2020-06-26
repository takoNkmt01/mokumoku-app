module DateAndTimeHelper
  WEEK_DAYS = %w[日 月 火 水 木 金 土].freeze

  # return 'MM/dd'
  def date_with_slash_without_year(datetime)
    datetime.strftime("%m/%d（#{WEEK_DAYS[datetime.wday]}）")
  end

  # return 'YYYY/MM/dd'
  def date_with_slash(datetime)
    datetime.strftime("%Y/%m/%d（#{WEEK_DAYS[datetime.wday]}）")
  end

  # return 'YYYY/MM/dd（w）HH:mm'
  def date_time_with_slash(datetime)
    datetime.strftime("%Y/%m/%d(#{WEEK_DAYS[datetime.wday]})%H:%M")
  end

  # return 'HH:mm ~ HH:mm
  def format_event_time(start_at, end_at)
    start_at.strftime('%H:%M') + ' ~ ' + end_at.strftime('%H:%M')
  end
end
