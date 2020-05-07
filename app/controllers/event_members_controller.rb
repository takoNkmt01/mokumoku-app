class EventMembersController < ApplicationController
  def index
  end

  def create
    unless logged_in?
      flash[:success] = 'イベントに参加するにはログインが必要です'
      return redirect_to login_path
    end

    @event_member = EventMember.new(event_member_params)

    if event_capacity_is_over?(@event_member.event)
      flash[:danger] = '定員オーバーにより申し込むことができません'
      return redirect_to event_path(@event_member.event)
    end

    if @event_member.save
      flash[:success] = 'イベント参加の申し込みが完了しました'
      redirect_to event_path(@event_member.event)
    else
      render 'events/show'
    end
  end

  def destroy
    @event_member = EventMember.find(params[:id])
    @event = @event_member.event
    @event_member.destroy
    flash[:success] = 'イベント参加のキャンセルが完了しました'
    redirect_to event_path(@event)
  end

  private

  def event_member_params
    params.require(:event_member).permit(:event_id, :user_id)
  end
end
