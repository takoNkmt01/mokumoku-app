class BookmarksController < ApplicationController
  before_action :login_check_before_bookmarks
  before_action :set_event, only: [:create, :destroy]

  def create
    bookmark = current_user.bookmarks.build(event_id: params[:event_id])
    ActiveRecord::Base.transaction do
      bookmark.save!
      # create and save notification
      @event.create_notification_bookmark!(current_user)
    end
  end

  def destroy
    ActiveRecord::Base.transaction do
      current_user.bookmarks.find_by(event_id: params[:event_id]).destroy!
      # delete notification which was bookmarked same event before
      current_user.active_notifications.find_by(event_id: params[:event_id], action: 'bookmark').destroy!
    end
  end

  private

  def login_check_before_bookmarks
    return if logged_in?

    flash[:success] = 'ログインしてください'
    redirect_to login_path
  end

  def set_event
    @event = Event.find(params[:event_id])
  end
end
