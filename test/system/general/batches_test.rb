require "application_system_test_case"

class BatchesTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    ActsAsTenant.current_tenant = @account
    @batch = batches(:group)
    sign_in @user
  end

  def page_url
    batches_url(script_name: "/#{@account.id}")
  end

  test "can show index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "Groups"
    assert_text "Save"
  end

  test "can not show index if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can show batch detail page" do
    visit page_url
    find("li", id: dom_id(@batch)).click
    within "#show" do
      assert_selector "h1", text: @batch.name
      assert_text "Add"
      take_screenshot
    end

    test "can create a new batch" do
      visit page_url
      fill_in "batch_name", with: "Badminton"
      click_on "Save"
      take_screenshot
      assert text: "Group was successfully created."
    end
  end

  test "can not create with empty name " do
    visit page_url
    click_on "Add batch"
    assert_selector "h1", text: "Add New Group"
    click_on "Save"
    take_screenshot
    assert_selector "h1", text: "Add New Group"
    assert_selector "div#error_explanation", text: "Name can't be blank"
  end

  test "can edit a batch" do
    visit page_url
    find("li", id: dom_id(@batch)).click_on("Edit")
    assert_selector "h1", text: @batch.decorate.display_name

    assert_selector "p.notice", text: "Group was successfully created."
  end

  test "can not edit a batch with invalid name" do
    visit page_url
    find("li", id: dom_id(@batch)).click
    assert_selector "h1", text: @batch.name

    take_screenshot
    assert_selector "h1", text: "Edit batch"
    assert_selector "div#error_explanation", text: "Phone number is not a number"
    assert_selector "div#error_explanation", text: "Phone number is too short (minimum is 10 characters)"
  end
end
