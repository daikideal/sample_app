require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  
  # テストユーザーを定義
  def setup
    @user       = users(:michael)
    @other_user = users(:archer)
    @non_activated = users(:non_activated)
  end
  
  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end
  
  test "should get new" do
    get signup_path
    assert_response :success
  end
  
  # editアクションの保護に対するテスト
  test "should redirect edit when not logged in" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end
  
  # updateアクションの保護に対するテスト
  test "should redirect update when not logged in" do
    # Usersコントローラのupdateアクションにつなぐ
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end
  
  # admin属性の変更が禁止されていることをテストする
  test "shoud not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: {
                    user: { password: "password",
                            password_confirmation: "password",
                            admin: true} }
    assert_not @other_user.reload.admin?
  end
  
  # ログインしていないユーザーがdeleteを実行した時の制御
  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end
  
  # 管理者以外のユーザーがdeleteを実行した時の制御
  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end
  
  test "should not allow the not activated attribute" do
    # 非有効化ユーザーでログイン
    log_in_as(@non_activated)
    # 有効化でないことを検証
    assert_not @non_activated.activated?
    # ユーザー一覧へ移動
    get users_path
    # 非有効化ユーザーが表示されていないことを確認
    assert_select "a[href=?]", user_path(@non_activated), count: 0
    # 非有効化ユーザーidのページを取得
    get user_path(@non_activated)
    # ルートurlにリダイレクトされればtrueを返す
    assert_redirected_to root_url
  end
  
  # フォロー/フォロワーページの認可のテスト
  test "should redirect following when not logged in" do
    get following_user_path(@user)
    assert_redirected_to login_url
  end
  
  test "should redirect followers when not logged in" do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end
  
end
