module AccessMapHelper
  # execute null check for latlng
  # if value is null, return 0
  def nil_check_for_latlng(lat_or_lng)
    lat_or_lng.nil? ? 0 : lat_or_lng
  end
end
