class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :following, :followers, :update, :destroy]
  before_action :deny_test_user, only: [:edit, :update, :destroy]
  before_action :same_user_check, only: [:edit, :update, :destroy]

  # GET /users
  def index
    @users = User.all.page(params[:page]).without_count.per(3)
  end

  # GET /signup
  def new
    @user = User.new
  end

  # POST /users
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

  # GET users/:id
  def show
    return unless logged_in?
    return if @user.id == current_user.id

    @room_id = Entry.acquire_room_id_if_exists(current_user.id, @user.id)
    @existed = true if @room_id

    return if @existed

    @room = Room.new
    @entry = Entry.new
  end

  # GET /users/:user_id/events/host
  # Events which is hosted by the target user
  def host
    @user = User.find(params[:user_id])
    @host_events = Event.select_host_events(@user.member_entries.where(organizer: true))
                        .page(params[:page]).without_count.per(3)
  end

  # GET /users/:user_id/events/join
  # Events which is joined by the target user
  def join
    @user = User.find(params[:user_id])
    @join_events = Event.select_join_events(@user.member_entries.where(organizer: false))
                        .page(params[:page]).without_count.per(3)
  end

  # GET /users/:user_id/bookmarks
  def bookmark
    @user = User.find(params[:user_id])
    @bookmark_events = current_user.bookmarks_events
                                   .page(params[:page]).without_count.per(3)
  end

  # GET /users/:user_id/rooms
  # get message rooms
  def rooms
    @user = User.find(params[:user_id])
    @entries = Entry.target_user_entry(Entry.where(user_id: @user.id))
  end

  # GET /users/:id/following
  # get following users
  def following
    @following = @user.following.page(params[:page]).without_count.per(5)
  end

  # GET /users/:id/follwers
  # get followers
  def followers
    @followers = @user.followers.page(params[:page]).without_count.per(5)
  end

  # GET /users/:id/edit
  def edit
  end

  # PATCH /users/:id
  def update
    if @user.update(user_params)
      flash[:success] = 'ユーザー情報を更新しました。'
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end

  # DELETE /users/:id
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

  def same_user_check
    require_same_user(@user)
  end

  # test user cannot edit,update and destroy own status
  def deny_test_user
    return unless current_user&.email == 'test_user@example.com'

    flash[:danger] = '申し訳ありません。テストユーザーはプロフィール変更をすることができません'
    redirect_to root_path
  end
end
