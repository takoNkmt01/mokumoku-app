class NotificationsController < ApplicationController
  def index
    @notifications = current_user.passive_notifications.page(params[:page]).without_count.per(3)
    @user = current_user
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
  end
end
