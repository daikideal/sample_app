class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  
  def new
  end
  
  # パスワード再設定用のcreateアクション
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
    @user = User.find_by(email: params[:email])
  end
  
  # フォームからの送信に対応し、パスワードを変更する
  def update
    # passwordが空文字だった場合を明示的にキャッチ
    if params[:user][:password].empty?
      @user.errors.add(:password, :blank)
      render 'edit'
    # 更新に成功
    elsif @user.update_attributes(user_params)
      log_in @user
      # パスワード再設定が成功したらダイジェストをnilにする
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "Password has been reset."
      redirect_to @user
    # 更新失敗時、ediビューを再描画
    else
      render 'edit'
    end
  end
  
  private
  
    # passwordとpassword_confirmation属性を精査
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
    
    # beforeフィルタ//
    
    def get_user
      @user = User.find_by(email: params[:email])
    end
    
    # 正しいユーザーかどうか判断する
    def valid_user
      unless(@user && @user.activated? && 
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end
    
    # トークンが期限切れかどうかを確認
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end
    
end
