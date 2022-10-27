require "application_system_test_case"

class ContactContactEventsTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    ActsAsTenant.current_tenant = @account
    sign_in @user
    @contact = contacts(:one)
  end

  def page_url
    contact_contact_events_url(script_name: "/#{@account.id}", contact_id: @contact.id)
  end

  test "can visit index page if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "#{@contact.first_name} #{@contact.last_name}"
    assert_text "Add Event"
  end

  test "can not visit index page if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can add new event" do
    visit page_url
    fill_in "contact_event_title", with: "Some Random Event Title"
    fill_in "contact_event_body", with: "Some Random Event Body"
    fill_in "contact_event_date", with: Time.now
    select life_events(:family_one).name.upcase_first, from: "contact_event_life_event_id"
    click_on "Add Event"
    assert_selector "#contact_events", text: "Some Random Event Title"
    take_screenshot
  end

  test "can add new event with reminder" do
    visit page_url
    fill_in "contact_event_title", with: "Random Event Title"
    fill_in "contact_event_body", with: "Some Random Event Body"
    fill_in "contact_event_date", with: Time.now
    check "reminder"
    select life_events(:family_one).name.upcase_first, from: "contact_event_life_event_id"
    click_on "Add Event"
    assert_selector "#contact_events", text: "Random Event Title"
    take_screenshot
    visit contact_reminders_url(script_name: "/#{@account.id}", contact_id: @contact.id)
    assert_selector "#reminders", text: "Random Event Title (#{life_events(:family_one).name.upcase_first})"
    take_screenshot
  end

  test "can not add event with empty params" do
    visit page_url
    click_on "Add Event"
    take_screenshot
    assert_selector "div#error_explanation", text: "Title can't be blank"
  end

  test "can edit a event" do
    visit page_url
    event = @contact.contact_events.first
    assert_text event.title
    find(id: dom_id(event)).click_link("Edit")
    take_screenshot
    within "#contact_events" do
      fill_in "contact_event_title", with: "Event Edited"
      click_on "Edit Event"
    end
    take_screenshot
    assert_no_text "Edit Event"
    assert_selector "##{dom_id(event)}", text: "Event Edited"
  end

  test "can not edit event with invalid params" do
    visit page_url
    event = @contact.contact_events.first
    assert_text event.title
    find(id: dom_id(event)).click_link("Edit")
    within "#contact_events" do
      fill_in "contact_event_title", with: ""
      click_on "Edit Event"
    end
    take_screenshot
    assert_selector "div#error_explanation", text: "Title can't be blank"
  end

  test "can delete a event" do
    visit page_url
    event = @contact.contact_events.first
    display_name = event.contact.decorate.display_name
    assert_text display_name
    page.accept_confirm do
      find(id: dom_id(event)).click_link("Delete")
    end
    assert_no_selector "tbody#contact_events", text: event.title
  end

  test "can not show add event when contact is inactive" do
    inactive_contact = contacts(:archived)
    visit contact_contact_events_url(script_name: "/#{@account.id}", contact_id: inactive_contact.id)
    assert_no_text "Add New Event"
  end
end
