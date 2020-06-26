class MessagesController < ApplicationController
  before_action :login_check

  def create
    if Entry.where(user_id: current_user.id, room_id: params[:message][:room_id]).present?
      @message = Message.create(message_params.merge(user_id: current_user.id))
      @messages = @message.room.messages.recent
    else
      flash[:alert] = 'メッセージ送信に失敗しました'
    end
  end

  def destroy
    @message = Message.find(params[:id])
    @messages = @message.room.messages.recent
    @message.destroy!
  end

  private

  def message_params
    params.require(:message).permit(:user_id, :body, :room_id)
  end

  def login_check
    return if logged_in?

    flash[:success] = 'ログインしてください'
    redirect_to login_path
  end
end
