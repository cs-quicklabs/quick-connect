require "application_system_test_case"

class ContactContactActivitiesTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    ActsAsTenant.current_tenant = @account
    sign_in @user
    @contact = contacts(:one)
  end

  def page_url
    contact_contact_activities_url(script_name: "/#{@account.id}", contact_id: @contact.id)
  end

  test "can visit index page if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "#{@contact.first_name} #{@contact.last_name}"
    assert_text "Add Activity"
  end

  test "can not visit index page if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can add new activity" do
    visit page_url
    fill_in "contact_activity_title", with: "Some Random Activity Title"
    fill_in "contact_activity_body", with: "Some Random Activity Body"
    fill_in "contact_activity_date", with: Time.now
    select activities(:simple_one).name.upcase_first, from: "contact_activity_activity_id"
    click_on "Add Activity"
    assert_selector "#contact_activities", text: "Some Random Activity Title"
    take_screenshot
  end

  test "can not add activity with empty params" do
    visit page_url
    click_on "Add Activity"
    take_screenshot
    assert_selector "div#error_explanation", text: "Title can't be blank"
  end

  test "can edit a activity" do
    visit page_url
    activity = @contact.contact_activities.first
    assert_text activity.title
    find(id: dom_id(activity)).click_link("Edit")
    take_screenshot
    within "#contact_activities" do
      fill_in "contact_activity_title", with: "Activity Edited"
      click_on "Edit Activity"
    end
    take_screenshot
    assert_no_text "Edit Activity"
    assert_selector "##{dom_id(activity)}", text: "Activity Edited"
  end

  test "can not edit activity with invalid params" do
    visit page_url
    activity = @contact.contact_activities.first
    assert_text activity.title
    find(id: dom_id(activity)).click_link("Edit")
    within "#contact_activities" do
      fill_in "contact_activity_title", with: ""
      click_on "Edit Activity"
    end
    take_screenshot
    assert_selector "div#error_explanation", text: "Title can't be blank"
  end

  test "can delete a activity" do
    visit page_url
    activity = @contact.contact_activities.first
    display_name = activity.contact.decorate.display_name
    assert_text display_name
    page.accept_confirm do
      find(id: dom_id(activity)).click_link("Delete")
    end
    assert_no_selector "tbody#contact_activities", text: activity.title
  end

  test "can not show add activity when contact is inactive" do
    inactive_contact = contacts(:archived)
    visit contact_contact_activities_url(script_name: "/#{@account.id}", contact_id: inactive_contact.id)
    assert_no_text "Add New Activity"
  end
end
