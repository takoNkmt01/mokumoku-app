class ApplicationController < ActionController::Base
  helper_method :zero_padding

  # zero_padding for month or day
  def zero_padding(number)
    format('%02d', number)
  end
end
