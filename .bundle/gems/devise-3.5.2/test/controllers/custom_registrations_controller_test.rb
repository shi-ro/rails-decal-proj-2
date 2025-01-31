require 'test_helper'

class CustomRegistrationsControllerTest < ActionController::TestCase
  tests Custom::RegistrationsController

  include Devise::TestHelpers

  setup do
    request.env["devise.mapping"] = Devise.mappings[:user]
    @password = 'password'
    @user = create_user(password: @password, password_confirmation: @password).tap(&:confirm)
  end

  test "yield resource to block on create success" do
    post :create, { user: { email: "user@example.org", password: "password", password_confirmation: "password" } }
    assert @controller.create_block_called?, "create failed to yield resource to provided block"
  end

  test "yield resource to block on create failure" do
    post :create, { user: { } }
    assert @controller.create_block_called?, "create failed to yield resource to provided block"
  end

  test "yield resource to block on update success" do
    sign_in @user
    put :update, { user: { current_password: @password } }
    assert @controller.update_block_called?, "update failed to yield resource to provided block"
  end

  test "yield resource to block on update failure" do
    sign_in @user
    put :update, { user: { } }
    assert @controller.update_block_called?, "update failed to yield resource to provided block"
  end

  test "yield resource to block on new" do
    get :new
    assert @controller.new_block_called?, "new failed to yield resource to provided block"
  end
end
