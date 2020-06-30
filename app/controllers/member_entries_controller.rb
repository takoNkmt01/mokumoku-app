class MemberEntriesController < ApplicationController
  before_action :login_check_before_join, only: [:create]

  def index
  end

  def create
    @member_entry = MemberEntry.new(member_entry_params)
    event = @member_entry.event

    if MemberEntry.capacity_is_over?(event)
      flash[:danger] = '定員オーバーにより申し込むことができません'
      return redirect_to event_path(event)
    end

    if @member_entry.save
      flash[:success] = 'イベント参加の申し込みが完了しました'
      redirect_to event_path(event)
    else
      render 'events/show'
    end
  end

  def destroy
    @member_entry = MemberEntry.find(params[:id])
    @member_entry.destroy
    flash[:success] = 'イベント参加のキャンセルが完了しました'
    redirect_to event_path(@member_entry.event)
  end

  private

  def member_entry_params
    params.require(:member_entry).permit(:event_id, :user_id)
  end

  def login_check_before_join
    return if logged_in?

    flash[:success] = 'イベントに参加するにはログインが必要です'
    redirect_to login_path
  end
end
