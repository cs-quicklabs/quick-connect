require "application_system_test_case"

class ContactRemindersTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    ActsAsTenant.current_tenant = @account
    sign_in @user
    @contact = contacts(:one)
  end

  def page_url
    contact_reminders_url(script_name: "/#{@account.id}", contact_id: @contact.id)
  end

  test "can visit index page if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "#{@contact.first_name} #{@contact.last_name}"
    assert_text "Add New Reminder"
  end

  test "can not visit index page if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can add new reminder" do
    visit page_url
    fill_in "reminder_title", with: "Random reminder title"
    fill_in "reminder_reminder_date", with: Date.today + 10.days
    choose(option: "once")
    fill_in "reminder_comments", with: "Some random comment"
    click_on "Add Reminder"
    assert_selector "tbody#reminders", text: "Random reminder title"
    take_screenshot
  end

  test "can not add reminder with empty params" do
    visit page_url
    click_on "Add Reminder"
    take_screenshot
    assert_selector "div#error_explanation", text: "Title can't be blank"
  end

  test "can edit a reminder" do
    visit page_url
    reminder = @contact.reminders.first
    assert_text reminder.title
    find("tr", id: dom_id(reminder)).click_link("Edit")
    take_screenshot
    fill_in "reminder_title", with: "Reminder Edited"
    click_on "Edit Reminder"
    take_screenshot
    assert_no_text "Edit Reminder"
    assert_selector "p.notice", text: "Reminder was successfully updated."
    assert_selector "tr##{dom_id(reminder)}", text: "Reminder Edited"
  end

  test "can not edit reminder with invalid params" do
    visit page_url
    reminder = @contact.reminders.first
    assert_text reminder.title
    find("tr", id: dom_id(reminder)).click_link("Edit")
    fill_in "reminder_title", with: ""
    click_on "Edit Reminder"
    take_screenshot
    assert_selector "div#error_explanation", text: "Title can't be blank"
  end

  test "can delete a reminder" do
    visit page_url
    reminder = @contact.reminders.first
    display_name = reminder.contact.decorate.display_name
    assert_text display_name
    page.accept_confirm do
      find("tr", id: dom_id(reminder)).click_link("Delete")
    end
    assert_no_selector "tbody#reminders", text: reminder.title
  end

  test "can not show add reminder when contact is inactive" do
    inactive_contact = contacts(:archived)
    visit contact_reminders_url(script_name: "/#{@account.id}", contact_id: inactive_contact.id)
    assert_no_text "Add New Reminder"
  end
end
