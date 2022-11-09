require "application_system_test_case"

class SearchTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    ActsAsTenant.current_tenant = @account
    @release_note = ReleaseNote.where(published: false).first
    sign_in @user
  end

  test "can search for employees" do
    visit dashboard_url(script_name: "/#{@account.id}")
    fill_in "navbar", with: "Co"
    first("#show").click
    assert_selector "h1", text: "Contact Two"
    take_screenshot
  end

  test "can search for groups" do
    visit dashboard_url(script_name: "/#{@account.id}")
    fill_in "navbar", with: "C"
    first("#group").click
    assert_selector "h1", text: "Cricket"
    assert_selector "h1", text: "Contact One"
    take_screenshot
  end
end
