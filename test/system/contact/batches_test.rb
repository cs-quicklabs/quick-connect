require "application_system_test_case"

class ContactBatchesTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    ActsAsTenant.current_tenant = @account
    sign_in @user
    @contact = contacts(:one)
  end

  def page_url
    contact_batches_url(script_name: "/#{@account.id}", contact_id: @contact.id)
  end

  test "can visit index page if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "#{@contact.first_name} #{@contact.last_name}"
    assert_text "Add Contact To Group"
  end

  test "can not visit index page if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can add contact to group" do
    visit page_url
    batch = batches(:group)
    select batch.name.titleize, from: "batch_id"
    click_on "Save"
    sleep(0.5)
    assert_selector "#batches", text: batch.name.upcase_first
    take_screenshot
  end

  test "can not add activity with empty params" do
    visit page_url
    click_on "Save"
    take_screenshot
    assert_selector "div#error_explanation", text: "Please select group"
  end

  test "can delete a group" do
    visit page_url
    batch = @contact.batches.first
    page.accept_confirm do
      find("tr", id: dom_id(batch)).click_link("Delete")
    end
    assert_no_selector "tbody#batches", text: batch.name
  end

  test "can not show add group when contact is inactive" do
    inactive_contact = contacts(:archived)
    visit contact_batches_url(script_name: "/#{@account.id}", contact_id: inactive_contact.id)
    assert_no_text "Add Contact To Group"
  end
end
