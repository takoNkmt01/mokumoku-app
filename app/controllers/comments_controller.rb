class CommentsController < ApplicationController
  before_action :login_check_before_comment

  def create
    @new_comment = Comment.new(comment_params)
    @new_comment.user_id = current_user.id
    @event = @new_comment.event
    ActiveRecord::Base.transaction do
      @new_comment.save!
      @event.create_notification_comment!(current_user, @new_comment.id)
    end
    after_process
  end

  def destroy
    @comment = Comment.find(params[:id])
    @event = @comment.event
    ActiveRecord::Base.transaction do
      Comment.reply_comments(@comment).destroy_all if Comment.exists?(reply_to: @comment.id)
      @comment.destroy
    end
    after_process
  end

  private

  def comment_params
    params.require(:comment).permit(:event_id, :text, :reply_to)
  end

  def after_process
    @comments = Comment.event_comments(@event).recent
    @new_comment = Comment.new
  end

  def login_check_before_comment
    return if logged_in?

    flash[:success] = 'コメントを投稿するにはログインが必要です。'
    redirect_to login_path
  end
end
