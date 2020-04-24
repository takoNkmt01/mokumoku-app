class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  def index
    @events = Event.all
  end

  def new
    @event = Event.new
  end

  def create
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
end
