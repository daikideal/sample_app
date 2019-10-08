require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  # Applicationヘルパーを読み込む
  include ApplicationHelper
  
  def setup
    @user = users(:michael)
  end
  
  test "profile display" do
    # プロフィール画面にアクセス
    get user_path(@user)
    assert_template 'users/show'
    # タイトルを確認
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    # h1の内側のgravatarクラスのimgタグをチェック
    assert_select 'h1>img.gravatar'
    # マイクロポストの数を確認
    assert_match @user.microposts.count.to_s, response.body
    # paginationを確認
    assert_select 'div.pagination', count: 1
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end
end
