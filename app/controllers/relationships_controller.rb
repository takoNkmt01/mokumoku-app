class RelationshipsController < ApplicationController
  before_action :login_check_before_following

  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow(@user)
    respond_to do |format|
      format.html { redirect_to user_path(@user) }
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
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
