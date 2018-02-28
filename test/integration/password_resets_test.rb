require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:michael)
  end
  
  test "password resets" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    #メールアドレスが無効
    post password_resets_path, params: {password_reset: {email: ""}}
    assert_not flash.empty?
    assert_template 'password_resets/new'
    
    #メールアドレスが有効
    post password_resets_path,
      params: {password_reset: {email:@user.email}}
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    
    #パスワード再設定フォームのテスト
    user = assigns(:user)
    
    #メールアドレスが無効
    get edit_password_reset_path(user.reset_token, email:"")
    assert_redirected_to root_url
    
    #メールアドレスが有効だがトークンが無効
    get edit_password_reset_path('wrong_token', email: user.email)
    assert_redirected_to root_url
    
    #メールアドレスもトークンも有効
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email
    
    #無効なpasswordとinvalid password confirmation
    patch password_reset_path(user.reset_token),
    params: {email: user.email,
          user: {password: "foobaz",
            password_confirmation: "barquux"} }
    assert_select 'div#error_explanation'
    
    #password is empty
    patch password_reset_path(user.reset_token),
      params: {email: user.email, 
        user:{password: "",
          password_confirmation: ""}}
    assert_select 'div#error_explanation'
    
    #valid password and its confirmation
    
    patch password_reset_path(user.reset_token),
      params: {email: user.email,
          user: {password: "foobaz",
            password_confirmation: "foobaz"
          }
      }
      assert is_logged_in?
      assert_not flash.empty?
      assert_redirected_to user
  end
  
    
    
end
