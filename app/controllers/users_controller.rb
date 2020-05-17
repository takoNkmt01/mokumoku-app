class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :show]
  before_action :deny_test_user, only: [:edit, :update, :destroy]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  before_action :require_admin, only: [:destroy]

  def index
    @users = User.all.page(params[:page]).per(3)
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
    @organized_events = @user.event_members.where(organizer: true)
    @will_join_events = @user.event_members.where(organizer: false)
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
    flash[:danger] = "#{@user.username}を削除しました"
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(
      :username,
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

  def require_admin
    return unless logged_in? && !current_user.admin?

    flash[:danger] = '不正なアクセスです'
    redirect_to root_path
  end

  def deny_test_user
    return unless current_user&.email == 'test_user@example.com'

    flash[:danger] = '申し訳ありません。テストユーザーはプロフィール変更をすることができません'
    redirect_to root_path
  end
end
