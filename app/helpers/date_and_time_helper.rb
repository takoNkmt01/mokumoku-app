module DateAndTimeHelper
  # return 'MM/dd'
  def date_with_slash_without_year(datetime)
    datetime.strftime("%m/%d（#{%w[日 月 火 水 木 金 土][datetime.wday]}）")
  end

  # return 'YYYY/MM/dd'
  def date_with_slash(datetime)
    datetime.strftime("%Y/%m/%d（#{%w[日 月 火 水 木 金 土][datetime.wday]}）")
  end

  # return 'HH:mm ~ HH:mm
  def format_event_time(start_at, end_at)
    start_at.strftime('%H:%M') + ' ~ ' + end_at.strftime('%H:%M')
  end
end
