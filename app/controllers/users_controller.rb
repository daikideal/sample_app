class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, 
                                        :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user, only: :destroy
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    redirect_to root_url and return unless @user.activated?
  end
  
  def new
    @user = User.new
  end
  
  def index
    # 有効化されたユーザーのみを一覧表示
    @users = User.where(activated: true).paginate(page: params[:page])
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      # ユーザーモデルオブジェクトからメールを送信
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your accout."
      redirect_to root_url
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  def following
    # タイトルを設定
    @title = "Following"
    # ユーザーを検索
    @user = User.find(params[:id])
    # データを取り出し、ページネーションを行って、出力
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end
  
  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
  
  private
    
    # 管理者以外のユーザーが編集できるのは以下の属性のみである
    def user_params
      params.require(:user).permit(:name, :email, :password, 
                                    :password_confirmation)
    end
    
    # beforeアクション
    
    # 正しいユーザーかどうか確認(editとupdateから@userへの代入を削除))
    def correct_user
      @user = User.find(params[:id])
      # 正しいユーザー以外はルートページへリダイレクト
      redirect_to(root_url) unless current_user?(@user)
    end
    
    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
    
end
