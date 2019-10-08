require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:michael)
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end
  
  # マイクロポスト有効性のテスト
  test "should be valid" do
    assert @micropost.valid?
  end
  
  # マイクロポストがユーザーIDを持っているかをチェック
  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end
  
  # 内容の存在性のテスト
  test "content should be present" do
    @micropost.content = " "
    assert_not @micropost.valid?
  end
  
  # 内容140字制限のテスト
  test "content should be at most 140 characters" do
    @micropost.content = "a"*141
    assert_not @micropost.valid?
  end
  
  # マイクロポストの順序づけをテストする
  test "order should be most recent first" do
    # データベース上の最初のマイクロポストが、
    # fixture内のマイクロポスト (most_recent) と同じであるか検証
    assert_equal microposts(:most_recent), Micropost.first
  end
  
end
