require "application_system_test_case"

class ContactPhoneCallsTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    ActsAsTenant.current_tenant = @account
    @contact = contacts(:one)
    sign_in @user
  end

  def page_url
    contact_phone_calls_url(script_name: "/#{@account.id}", contact_id: @contact.id)
  end

  test "can visit index page if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "#{@contact.decorate.display_name}"
    assert_text "Phone Calls"
    assert_text "Add New Phone Call"
  end

  test "can not visit index page if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can add a new phone_call" do
    visit page_url
    fill_in "phone_call_body", with: "Added some phone call"
    click_on "Add Phone Call"
    within "#phone_calls" do
      assert_text "Added some phone call"
    end
    take_screenshot
  end

  test "can not add an empty phone call" do
    visit page_url
    click_on "Add Phone Call"
    assert_selector "div#error_explanation", text: "Body can't be blank"
    take_screenshot
  end

  test "can delete a phone call" do
    visit page_url
    phone_call = @contact.phone_calls.first
    assert_text phone_call.body
    page.accept_confirm do
      find("turbo-frame", id: dom_id(phone_call)).click_link("Delete")
    end
    assert_no_text phone_call.body
    take_screenshot
  end

  test "can not show add phone calls when contact is archived" do
    archived_contact = contacts(:archived)
    visit contact_phone_calls_url(script_name: "/#{@account.id}", contact_id: archived_contact.id)
    assert_no_text "Add New Phone Call"
  end

  test "can edit a phone call" do
    visit page_url
    phone_call = @contact.phone_calls.first
    assert_text phone_call.body
    find("turbo-frame", id: dom_id(phone_call)).click_link("Edit")
    take_screenshot
    within "#phone_calls" do
      fill_in "phone_call_body", with: "phone_calld Edited"
      click_on "Edit Phone Call"
      take_screenshot
      assert_no_text "Edit phone_call"
    end
  end

  test "can not edit phone_call with invalid params" do
    visit page_url
    phone_call = @contact.phone_calls.first
    assert_text phone_call.body
    find("turbo-frame", id: dom_id(phone_call)).click_link("Edit")
    within "#phone_calls" do
      fill_in "phone_call_body", with: ""
      click_on "Edit Phone Call"
      take_screenshot
      assert_selector "div#error_explanation", text: "Body can't be blank"
    end
  end
end
