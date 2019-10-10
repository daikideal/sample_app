require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    @other = users(:archer)
    log_in_as(@user)
  end
  
  test "following page" do
    get following_user_path(@user)
    # まずフォローが空でないことを確認
    assert_not @user.following.empty?
    # 正しいフォロー数かどうかテスト
    assert_match @user.following.count.to_s, response.body
    # 正しいURLかどうかテスト
    @user.following.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end
  
  test "followers page" do
    get followers_user_path(@user)
    # まずフォロワーが空でないことを確認
    assert_not @user.followers.empty?
    # 正しいフォロワー数かどうかテスト
    assert_match @user.followers.count.to_s, response.body
    # 正しいURLかどうかテスト
    @user.followers.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end
  
  # 通常のフォローのテスト
  test "should follow a user the standard way" do
    # /relationshipsにPOSTリクエストを送り、フォローが1増えたことをチェック
    assert_difference '@user.following.count', 1 do
      post relationships_path, params: { followed_id: @other.id }
    end
  end
  
  # Ajaxを用いたフォローのテスト
  test "should follow a user with Ajax" do
    assert_difference '@user.following.count', 1 do
      # 'xhr: true'でAjaxオプションを使用
      post relationships_path, xhr: true, params: { followed_id: @other.id }
    end
  end
  
  # 通常のフォロー解除のテスト
  test "should unfollow a user the standard way" do
    # まず他のユーザーをフォロー
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    # /relationshipsにDELETEリクエストを送り、フォローが1減ったことをチェック
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship)
    end
  end
  
  # Ajaxを用いたフォロー解除のテスト
  test "should unfollow a user with Ajax" do
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship), xhr: true
    end
  end
  
end
