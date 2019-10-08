class StaticPagesController < ApplicationController
  
  def home
    # サンプルアプリケーションにフィード機能を導入するための準備
    if logged_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
  
end
