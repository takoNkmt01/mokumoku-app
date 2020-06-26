class RoomsController < ApplicationController
  before_action :login_check_before_messages

  def create
    room_id = Entry.acquire_room_id_if_exists(current_user.id, params[:entry][:user_id])
    unless room_id
      ActiveRecord::Base.transaction do
        @room = Room.create
        room_id = @room.id
        @entry1 = Entry.create(room_id: @room.id, user_id: current_user.id)
        @entry2 = Entry.create(entry_params.merge(room_id: @room.id))
      end
    end
    redirect_to "/users/#{current_user.id}/rooms/#{room_id}"
  end

  def show
    @user = current_user
    @room = Room.find(params[:id])
    if Entry.where(user_id: current_user.id, room_id: @room.id).present?
      @messages = @room.messages.recent.page(params[:page]).without_count.per(3)
      @message = Message.new
      @send_to = @room.entries.find_by('user_id != ?', current_user.id)
    else
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def entry_params
    params.require(:entry).permit(:user_id, :room_id)
  end

  def login_check_before_messages
    return if logged_in?

    flash[:success] = 'ログインしてください'
    redirect_to login_path
  end
end
