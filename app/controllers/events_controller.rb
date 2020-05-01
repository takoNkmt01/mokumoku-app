class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :set_new_event, only: [:new, :create]
  before_action :require_user, except: [:index, :show]
  before_action :require_same_user, only: [:edit, :update, :destroy]

  def index
    @q = Event.all.order(created_at: :desc)
    @events = @q.page(params[:page]).per(5)
  end

  def new
    @event.map = Map.new
    @event_with_map = Events::WithMapForm.new(@event)
  end

  def create
    @event_with_map = Events::WithMapForm.new(@event, event_params)
    if @event_with_map.save
      flash[:success] = '新規イベントを登録しました'
      redirect_to user_path(current_user)
    else
      render 'new'
    end
  end

  def show
    @event_user = @event.user
  end

  def edit
    @event_with_map = Events::WithMapForm.new(@event)
  end

  def update
    @event_with_map = Events::WithMapForm.new(@event, event_params)
    if @event_with_map.save
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

  def set_new_event
    @event = Event.new
    @event.user = current_user
  end

  def event_params
    params.require(:events_with_map_form).permit(
      event_attributes: [
        :event_name,
        :event_content,
        :overview,
        :event_capacity,
        :start_at,
        :end_at,
        :necessities
      ],
      map_attributes: [
        :address
      ]
    )
  end

  def require_same_user
    return unless current_user != @event.user && !current_user.admin?

    flash[:danger] = '不正なアクセスです'
    redirect_to user_path(current_user)
  end
end