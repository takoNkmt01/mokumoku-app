class RelationshipsController < ApplicationController
  before_action :login_check_before_following

  def create
    @user = User.find(params[:relationship][:followed_id])
    ActiveRecord::Base.transaction do
      current_user.follow(@user)
      @user.create_notification_follow!(current_user)
    end
    respond_to do |format|
      format.html { redirect_to user_path(@user) }
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    ActiveRecord::Base.transaction do
      current_user.unfollow(@user)
      # delete notification which is relationship created before
      current_user.active_notifications.find_by(visited_id: @user.id, action: 'follow').destroy!
    end
    respond_to do |format|
      format.html { redirect_to user_path(@user) }
      format.js
    end
  end

  private

  def login_check_before_following
    return if logged_in?

    flash[:success] = '操作を行うにはログインしてください'
    redirect_to login_path
  end
end
