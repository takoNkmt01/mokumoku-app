class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :set_new_event, only: [:new, :create]
  before_action :require_user, except: [:index, :show]
  before_action :require_same_user, only: [:edit, :update, :destroy]

  def index
    @search_param = params[:keyword].present? ? params[:keyword] : nil
    if @search_param
      keywords = @search_param.tr('　', ' ').strip.split(' ')
      @events = Event.multi_keyword_search(keywords).page(params[:page]).per(5)
      @search_param = keywords.join(', ')
    else
      @events = Event.recent.page(params[:page]).per(5)
    end
    @tags = Tag.all
  end

  def new
    @event.access_map = AccessMap.new
    @event_with_access_map = Events::WithAccessMapForm.new(@event)
  end

  def create
    tags_list = params[:tag_name].split(' ')
    @event_with_access_map = Events::WithAccessMapForm.new(@event, event_params, tags_list)

    if @event_with_access_map.save
      register_organizer_to_member_entry(@event_with_access_map)

      flash[:success] = '新規イベントを登録しました'
      redirect_to user_path(current_user)
    else
      render 'new'
    end
  end

  def show
    @event_user = @event.user
    @member_entry =
      if logged_in? && MemberEntry.exists?(event_id: @event.id, user_id: current_user.id)
        MemberEntry.find_by(event_id: @event.id, user_id: current_user.id)
      else
        MemberEntry.new
      end

    @comments = Comment.where(event_id: @event.id).order(created_at: :desc)
                       .page(params[:page]).without_count.per(3)
    @new_comment = Comment.new
  end

  def edit
    @event_with_access_map = Events::WithAccessMapForm.new(@event)
  end

  def update
    tags_list = params[:tag_name].split(' ')
    @event_with_access_map = Events::WithAccessMapForm.new(@event, event_params, tags_list)
    if @event_with_access_map.save
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
    params.require(:events_with_access_map_form).permit(
      event_attributes: [
        :title,
        :content,
        :overview,
        :capacity,
        :start_at,
        :end_at,
        :necessities
      ],
      access_map_attributes: [
        :address
      ]
    )
  end

  def register_organizer_to_member_entry(event_with_access_map)
    member_entry = MemberEntry.new(
      event_id: event_with_access_map.event.id,
      user_id: current_user.id,
      organizer: true
    )
    member_entry.save
  end

  def require_same_user
    return unless current_user != @event.user && !current_user.admin?

    flash[:danger] = '不正なアクセスです'
    redirect_to user_path(current_user)
  end
end
