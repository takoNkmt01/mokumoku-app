class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :deny_test_user, only: [:edit, :update, :destroy]
  before_action :require_same_user, only: [:edit, :update, :destroy]

  def index
    @users = User.all.page(params[:page]).without_count.per(3)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      flash[:success] = 'ユーザー登録が完了しました'
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end

  def show
    return unless logged_in?
    unless @user.id == current_user.id
      @room_id = Entry.acquire_room_id_if_exists(current_user.id, @user.id)
      @existed = true if @room_id
      unless @existed
        @room = Room.new
        @entry = Entry.new
      end
    end
  end

  def host
    @user = User.find(params[:user_id])
    @host_events = Event.select_host_events(@user.event_members.where(organizer: true))
                        .page(params[:page]).without_count.per(3)
  end

  def join
    @user = User.find(params[:user_id])
    @join_events = Event.select_join_events(@user.event_members.where(organizer: false))
                        .page(params[:page]).without_count.per(3)
  end

  def bookmark
    @user = User.find(params[:user_id])
    @bookmark_events = current_user.bookmarks_events
                                   .page(params[:page]).without_count.per(3)
  end

  def rooms
    @user = User.find(params[:user_id])
    @entries = Entry.target_user_entry(Entry.where(user_id: @user.id))
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = 'ユーザー情報を更新しました。'
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    reset_session
    flash[:danger] = 'ご利用ありがとうございました。またのご利用をお待ちしております。'
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(
      :full_name,
      :email,
      :password,
      :password_confirmation,
      :profile,
      :image
    )
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_same_user
    return unless current_user != @user && !current_user&.admin?

    flash[:danger] = '不正なアクセスです'
    redirect_to root_path
  end

  def deny_test_user
    return unless current_user&.email == 'test_user@example.com'

    flash[:danger] = '申し訳ありません。テストユーザーはプロフィール変更をすることができません'
    redirect_to root_path
  end
end
