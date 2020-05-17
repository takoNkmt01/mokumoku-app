class TestUserController < ApplicationController
  def create
    test_user = User.find_by(email: 'test_user@example.com')
    session[:user_id] = test_user.id
    flash[:success] = 'テストユーザーとしてログインしました。'
    redirect_to user_path(test_user)
  end
end
