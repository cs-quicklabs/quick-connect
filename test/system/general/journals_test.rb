require "application_system_test_case"

class JournalsTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    ActsAsTenant.current_tenant = @account
    @journal = journals(:one)
    sign_in @user
  end

  def page_url
    journals_url(script_name: "/#{@account.id}")
  end

  def journals_page_url
    journal_url(script_name: "/#{@account.id}", journal_id: @journal.id)
  end

  test "can show index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "Journals"
    assert_text "Add Journal"
  end

  test "can not show index if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can show journal detail page" do
    visit page_url
    find(id: dom_id(@journal)).click
    within "#journal-header" do
      assert_text "Edit"
      assert_text "Delete"
    end
    take_screenshot
  end

  test "can create a new journal" do
    visit page_url
    click_on "Add Journal"
    fill_in "journal_title", with: "Journal"
    fill_in "journal_body", with: "This is some journal"
    click_on "Save"
    take_screenshot
    assert_selector "p.notice", text: "Journal was successfully created."
  end

  test "can add rating for the day" do
    visit page_url
    within "#rating" do
      find("li", id: "add-rating-awesome").click
    end

    assert_selector "p", text: "Your day was awesome!"
  end

  test "can not create with empty Name Discription" do
    visit page_url
    click_on "Add Journal"
    assert_selector "h1", text: "Add New Journal"
    click_on "Save"
    take_screenshot
    assert_selector "div#error_explanation", text: "Title can't be blank"
    assert_selector "div#error_explanation", text: "Body can't be blank"
  end

  test "can edit a journal" do
    visit page_url
    find(id: dom_id(@journal)).click
    within "#journal-header" do
      click_on "Edit"
    end
    assert_selector "h1", text: "Edit Journal"
    fill_in "journal_title", with: "Journal"
    fill_in "journal_body", with: "This is some journal"
    click_on "Save"
    assert_selector "p.notice", text: "Journal was successfully updated."
  end

  test "can not edit a journal with invalid name" do
    visit page_url
    find(id: dom_id(@journal)).click
    within "#journal-header" do
      click_on "Edit"
    end
    assert_selector "h1", text: "Edit Journal"
    fill_in "journal_title", with: ""
    click_on "Save Journal"
    take_screenshot
  end

  test "can delete journal" do
    visit page_url
    find(id: dom_id(@journal)).click
    within "#journal-header" do
      page.accept_confirm do
        click_on "Delete"
      end
    end
    take_screenshot
    assert_selector "p.notice", text: "Journal was successfully deleted."
  end
end
