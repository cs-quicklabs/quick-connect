require "application_system_test_case"

class ContactConversationsTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    ActsAsTenant.current_tenant = @account
    @contact = contacts(:one)
    sign_in @user
  end

  def page_url
    contact_conversations_url(script_name: "/#{@account.id}", contact_id: @contact.id)
  end

  test "can visit index page if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "#{@contact.decorate.display_name}"
    assert_text "Conversations"
    assert_text "Add New Conversation"
  end

  test "can not visit index page if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can add a new conversation" do
    visit page_url
    fill_in "conversation_body", with: "Added some phone call"
    fill_in "conversation_date", with: Date.today
    select fields(:email).name, from: "conversation_field_id"
    click_on "Add Conversation"
    within "#conversations" do
      assert_text "Added some phone call"
    end
    take_screenshot
  end

  test "can not add an empty phone call" do
    visit page_url
    click_on "Add Conversation"
    assert_selector "div#error_explanation", text: "Conversation can't be blank"
    assert_selector "div#error_explanation", text: "Contact field type must exist"
    take_screenshot
  end

  test "can delete a phone call" do
    visit page_url
    conversation = @contact.conversations.first
    assert_text conversation.body
    page.accept_confirm do
      find("turbo-frame", id: dom_id(conversation)).click_link("Delete")
    end
    assert_no_text conversation.body
    take_screenshot
  end

  test "can not show add phone calls when contact is archived" do
    archived_contact = contacts(:archived)
    visit contact_conversations_url(script_name: "/#{@account.id}", contact_id: archived_contact.id)
    assert_no_text "Add New Conversation"
  end

  test "can edit a conversation" do
    visit page_url
    conversation = @contact.conversations.first
    assert_text conversation.body
    find("turbo-frame", id: dom_id(conversation)).click_link("Edit")
    take_screenshot
    within "#conversations" do
      fill_in "conversation_body", with: "Added some phone call"
      fill_in "conversation_date", with: Date.today
      select fields(:email).name, from: "conversation_field_id"
      click_on "Edit Conversation"
      take_screenshot
      assert_no_text "Edit conversation"
    end
  end

  test "can not edit conversation with invalid params" do
    visit page_url
    conversation = @contact.conversations.first
    assert_text conversation.body
    find("turbo-frame", id: dom_id(conversation)).click_link("Edit")
    within "#conversations" do
      fill_in "conversation_body", with: ""
      click_on "Edit Conversation"
      take_screenshot
      assert_selector "div#error_explanation", text: "Conversation can't be blank"
    end
  end
end
