require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  # 無効なユーザー登録に対するテスト
  test "invalid signup infomation" do
    get signup_path
    assert_no_difference 'User.count' do
      post signup_path, params: { user: {  name:  "", 
                                          email: "user@invalid", 
                                          password:              "foo",
                                          password_confirmation: "bar" } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation ul'
    assert_select 'div.field_with_errors'
    assert_select 'form[action="/signup"]'
  end
  
  # 有効なユーザー登録に対するテスト
  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: {user: { name: "Example User",
                                        email: "user@example.com",
                                        password: "password",
                                        password_confirmation: "password"}}
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.alert
  end
end
