class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :require_user, except: [:index, :show]
  before_action :require_same_user, only: [:edit, :update, :destroy]

  def index
    @q = Event.all.order(created_at: :desc)
    @events = @q.page(params[:page]).per(5)
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.user = current_user
    if @event.save
      flash[:success] = '新規イベントを登録しました'
      redirect_to event_path(@event)
    else
      render 'new'
    end
  end

  def show
    @event_user = @event.user
  end

  def edit
    @event_user = @event.user
  end

  def update
    if @event.update(event_params)
      flash[:success] = 'イベント情報を更新しました。'
      redirect_to event_path(@event)
    else
      render 'edit'
    end
  end

  def destroy
    @event.destroy
    flash[:danger] = 'イベントを削除しました'
    redirect_to user_path(current_user)
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(
      :event_name,
      :event_content,
      :overview,
      :event_capacity,
      :start_at,
      :end_at,
      :necessities
    )
  end

  def require_same_user
    return unless current_user != @event.user && !current_user.admin?

    flash[:danger] = '不正なアクセスです'
    redirect_to user_path(current_user)
  end
end
