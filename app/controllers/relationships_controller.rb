class RelationshipsController < ApplicationController
  # リレーションシップのアクセス制御にログインを要求
  before_action :logged_in_user
  
  # [Follow]ボタン
  def create
    # フォームから送られてきたパラメータを使ってユーザーを検索
    @user = User.find(params[:followed_id])
    # フォロー
    current_user.follow(@user)
    # Ajax対応
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
  
  # [Unfollow]ボタン
  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
  
end