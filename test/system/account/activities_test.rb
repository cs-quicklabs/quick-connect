require "application_system_test_case"

class ActivitiesTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    sign_in @user
  end

  def page_url
    account_activities_url(script_name: "/#{@account.id}")
  end

  test "can visit the index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "Add New Activity"
  end

  test "should have left menu with  Activities selected" do
    visit page_url
    within "#menu" do
      assert_selector ".selected", text: "Activities"
    end
  end

  test "redirect to login if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can add a new activity" do
    visit page_url
    select groups(:cultural).name, from: "activity_group_id"
    fill_in "activity_name", with: "played a sport together"
    click_on "Save"
    take_screenshot
    assert_text "Activity was created successfully"
    assert_selector "#activity_name", text: ""
  end

  test "can not add an empty activity" do
    visit page_url
    click_on "Save"
    assert_selector "div#error_explanation", text: "Name can't be blank"
    take_screenshot
  end
  test "can not add a duplicate activity" do
    visit page_url
    fill_in "activity_name", with: activities(:simple_one).name
    click_on "Save"
    take_screenshot
    assert_text "Name has already been taken"
  end

  test "can visit edit page" do
    visit edit_account_activity_url(activities(:simple_one), script_name: "/#{@account.id}")
    page.assert_selector(:xpath, "/html/body/main/turbo-frame/form/li/div")
  end

  test "can edit activity" do
    visit page_url
    activity = activities(:simple_one)
    assert_selector "li", text: activity.name
    find("li", text: activity.name).click_on("Edit")
    within "turbo-frame#activity_#{activity.id}" do
      fill_in "activity_name", with: "Edited Name"
      click_on "Save"
    end
    assert_selector "li", text: "Edited Name"
  end

  test "can delete a  activity" do
    visit page_url
    activity = activities(:simple_two)
    assert_selector "li", text: activity.name
    page.accept_confirm do
      find("li", text: activity.name).click_on("Delete")
    end
    assert_no_selector "li", text: activity.name
  end

  test "can not edit activity with existing name" do
    visit page_url
    activity = activities(:simple_one)
    two = activities(:simple_two)
    assert_selector "li", text: activity.name
    find("li", text: activity.name).click_on("Edit")
    within "turbo-frame#activity_#{activity.id}" do
      fill_in "activity_name", with: two.name
      click_on "Save"
      take_screenshot
      assert_text "Name has already been taken"
    end
  end
end
