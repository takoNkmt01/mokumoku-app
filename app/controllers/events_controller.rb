class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  def index
    @events = Event.all
  end

  def new
    @event = Event.user
  end

  def show
    @event_user = @event.user
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end
end
