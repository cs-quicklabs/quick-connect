require "application_system_test_case"

class ContactDocumentsTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    ActsAsTenant.current_tenant = @account
    @contact = contacts(:one)
    sign_in @user
  end

  def page_url
    contact_documents_url(script_name: "/#{@account.id}", contact_id: @contact.id)
  end

  def edit_page_url
    edit_contact_document_url(script_name: "/#{@account.id}", contact_id: @contact.id, id: @document.id)
  end

  test "can visit index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "#{@contact.first_name} #{@contact.last_name}"
    assert_selector "div#contact-tabs", text: "Documents"
    assert_selector "form#new_document"
  end

  test "can not visit index if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can add new document" do
    visit page_url
    fill_in "document_filename", with: "Some Random document"
    fill_in "document_link", with: "www.google.com"
    fill_in "document_comments", with: "This is comment"
    click_on "Add Document"
    take_screenshot
    assert_selector "#documents", text: "Some Random document"
  end

  test "can not add document with empty details" do
    visit page_url
    click_on "Add Document"
    assert_selector "div#error_explanation", text: "Filename can't be blank"
    assert_selector "div#error_explanation", text: "Link can't be blank"
    take_screenshot
  end

  test "can delete a document" do
    @document = @contact.documents.first
    visit page_url
    page.accept_confirm do
      find("turbo-frame", id: dom_id(@document)).click_link("Delete")
    end
    assert_no_selector "##{dom_id(@document)}"
    take_screenshot
  end

  test "can not show add document when contact is archived" do
    inactive_contact = contacts(:archived)
    visit contact_documents_url(script_name: "/#{@account.id}", contact_id: inactive_contact.id)
    assert_no_selector "form#new_document"
  end

  test "can edit document" do
    visit page_url
    document = @contact.documents.first
    assert_text document.filename
    find("turbo-frame", id: dom_id(document)).click_link("Edit")
    within "#documents" do
      fill_in "document_comments", with: "comments"
    end
    take_screenshot
    click_on "Edit Document"
    assert_selector "##{dom_id(document)}", text: "comments"
    take_screenshot
  end

  test "can not edit document with invalid params" do
    visit page_url
    document = @contact.documents.first
    assert_text document.filename
    find("turbo-frame", id: dom_id(document)).click_link("Edit")
    take_screenshot
    within "#documents" do
      fill_in "document_link", with: nil
      click_on "Edit Document"
    end
    assert_selector "div#error_explanation", text: "Link can't be blank"
    take_screenshot
  end
end
