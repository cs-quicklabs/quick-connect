require "application_system_test_case"

class ContactNotesTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    ActsAsTenant.current_tenant = @account
    @contact = contacts(:one)
    sign_in @user
  end

  def page_url
    contact_notes_url(script_name: "/#{@account.id}", contact_id: @contact.id)
  end

  test "can visit index page if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "#{@contact.decorate.display_name}"
    assert_text "Notes"
    assert_text "Add New Note"
  end

  test "can not visit index page if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can add a new note" do
    visit page_url
    fill_in "note_body", with: "Added some note"
    click_on "Add Note"
    within "#notes" do
      assert_text "Added some note"
    end
    take_screenshot
  end

  test "can not add an empty note" do
    visit page_url
    click_on "Add Note"
    assert_selector "div#error_explanation", text: "Description can't be blank"
    take_screenshot
  end

  test "can delete a note" do
    visit page_url
    note = @contact.notes.first
    assert_text note.body
    page.accept_confirm do
      find("turbo-frame", id: dom_id(note)).click_link("Delete")
    end
    assert_no_text note.body
    take_screenshot
  end

  test "can not show add notes when contact is archived" do
    archived_contact = contacts(:archived)
    visit contact_notes_url(script_name: "/#{@account.id}", contact_id: archived_contact.id)
    assert_no_text "Add New Note"
  end

  test "can edit a note" do
    visit page_url
    note = @contact.notes.first
    assert_text note.body
    find("turbo-frame", id: dom_id(note)).click_link("Edit")
    take_screenshot
    within "#notes" do
      fill_in "note_body", with: "Noted Edited"
      click_on "Edit Note"
      take_screenshot
      assert_no_text "Edit Note"
    end
  end

  test "can not edit note with invalid params" do
    visit page_url
    note = @contact.notes.first
    assert_text note.body
    find("turbo-frame", id: dom_id(note)).click_link("Edit")
    within "#notes" do
      fill_in "note_body", with: ""
      click_on "Edit Note"
      take_screenshot
      assert_selector "div#error_explanation", text: "Description can't be blank"
    end
  end
end
