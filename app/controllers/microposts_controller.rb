class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy
  
  # マイクロポスト投稿（作成）
  def create
    @micropost = current_user.microposts.build(micropost_params)
    # ログイン済みのトップページにリダイレクト
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end
  
  # マイクロポスト削除
  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    # 1つ前のurlを返す（今回はHomeページ）、デフォルトはrootページ
    # redirect_to request.referrer || root_url
    redirect_back(fallback_location: root_url)
  end
  
  private
  
    # マイクロポストのcontentとpictureだけをweb経由で変更できるようにする
    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end
    
    # 現在のユーザーが削除対象のマイクロポストを保有しているか確認
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
  
end
