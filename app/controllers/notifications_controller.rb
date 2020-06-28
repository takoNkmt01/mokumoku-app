class NotificationsController < ApplicationController
  def index
    @notifications = current_user.passive_notifications.page(params[:page]).without_count.per(3)
    @user = current_user
  end
end
