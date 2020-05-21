class EventMembersController < ApplicationController
  before_action :login_check_before_join, only: [:create]

  def index
  end

  def create
    @event_member = EventMember.new(event_member_params)
    event = @event_member.event

    if event_capacity_is_over?(event)
      flash[:danger] = '定員オーバーにより申し込むことができません'
      return redirect_to event_path(event)
    end

    if @event_member.save
      flash[:success] = 'イベント参加の申し込みが完了しました'
      redirect_to event_path(event)
    else
      render 'events/show'
    end
  end

  def destroy
    @event_member = EventMember.find(params[:id])
    @event_member.destroy
    flash[:success] = 'イベント参加のキャンセルが完了しました'
    redirect_to event_path(@event_member.event)
  end

  private

  def event_member_params
    params.require(:event_member).permit(:event_id, :user_id)
  end

  def login_check_before_join
    return if logged_in?

    flash[:success] = 'イベントに参加するにはログインが必要です'
    redirect_to login_path
  end
end
