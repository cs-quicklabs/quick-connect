require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    sign_in @user
  end

  def page_url
    user_profile_url(script_name: "/#{@account.id}")
  end

  test "can visit profile page if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "Profile"
  end

  test "can not visit profile page if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can edit user profile" do
    visit page_url
    click_on "Save"
    take_screenshot
    assert_text "User was updated successfully"
  end

  test "can not edit user profile with empty name email" do
    visit page_url
    fill_in "First Name", with: ""
    fill_in "Last Name", with: ""
    click_on "Save"
    take_screenshot
    assert_text "First name can't be blank"
    assert_text "Last name can't be blank"
  end

  test "can not update password with pawned password" do
    visit setting_password_url(script_name: "/#{@account.id}")
    fill_in "user_original_password", with: "random123"
    fill_in "user_new_password", with: "Home@123"
    fill_in "user_new_password_confirmation", with: "Home@123"
    click_on "Save"
    sleep(1)
    take_screenshot
    assert_text "New password has previously appeared in a data breach and should not be used"
  end

  test "can not update password with empty fields" do
    visit setting_password_url(script_name: "/#{@account.id}")
    click_on "Save"
    take_screenshot
    assert_text "Original password can't be blank"
    assert_text "New password can't be blank"
    assert_text "New password confirmation can't be blank"
    assert_text "Original password is not correct"
    assert_text "New password is too short (minimum is 6 characters)"
  end

  test "can reset user " do
    visit page_url
    take_screenshot
    page.accept_confirm do
      click_on "Reset Account"
    end
    assert_text "Your account has been reset successfully."
  end
  test "can destroy user " do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "Profile"
    page.accept_confirm do
      click_on "Delete Account"
    end
    assert_text "Your account has been deleted successfully."
  end
end
