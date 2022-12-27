require "application_system_test_case"

class ReleaseNotesTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    ActsAsTenant.current_tenant = @account
    @release_note = ReleaseNote.where(published: false).first
    sign_in @user
  end

  def page_url
    whatsnew_url(script_name: "/#{@account.id}")
  end

  test "can view release notes if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "What's New"
  end

  test "can not show index if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can create a new release_note" do
    visit page_url
    click_on "Add Release Note"
    fill_in "release_note_title", with: "Release Note"
    fill_in_rich_text_area "new_release_note", with: "This is some nugget"
    click_on "Save"
    take_screenshot
    assert_selector "p.notice", text: "Release Note was successfully created."
  end

  test "can not create with empty Name Discription" do
    visit page_url
    click_on "Add Release Note"
    assert_selector "h1", text: "Add New Release Note"
    page.accept_confirm do
      click_on "Publish Release Note"
    end
    take_screenshot
    assert_selector "div#error_explanation", text: "Title can't be blank"
    assert_selector "div#error_explanation", text: "Description can't be blank"
  end

  test "can edit a release_note if not published" do
    visit page_url
    find("turbo-frame", id: dom_id(@release_note)).click_link("Edit")
    assert_selector "h1", text: "Edit Release Note"
    fill_in "release_note_title", with: "Release Note"
    fill_in_rich_text_area dom_id(@release_note), with: "This is some new"
    page.accept_confirm do
      click_on "Publish Release Note"
    end
    assert_selector "p.notice", text: "Release Note was successfully updated."
  end

  test "can not edit a release_note if published" do
    visit page_url
    @release_note = ReleaseNote.where(published: true).first
    within "turbo-frame##{dom_id(@release_note)}" do
      assert_no_text "Edit"
    end
  end

  test "can not edit a release_note with invalid name" do
    visit page_url
    find("turbo-frame", id: dom_id(@release_note)).click_link("Edit")
    assert_selector "h1", text: "Edit Release Note"
    fill_in "release_note_title", with: ""
    click_on "Save"
    take_screenshot
  end

  test "can delete release_note" do
    visit page_url
    page.accept_confirm do
      find("turbo-frame", id: dom_id(@release_note)).click_link("Delete")
    end
    take_screenshot
    assert_no_selector "#release_notes", text: @release_note.title
  end
end
