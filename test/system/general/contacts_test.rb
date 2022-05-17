require "application_system_test_case"

class ContactsTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    ActsAsTenant.current_tenant = @account
    @contact = contacts(:contact)
    sign_in @user
  end

  def page_url
    contacts_url(script_name: "/#{@account.id}")
  end

  def contacts_page_url
    contacts_url(script_name: "/#{@account.id}", contact_id: @contact.id)
  end

  test "can show index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "Contacts"
    assert_text "Add Contact"
  end

  test "can not show index if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can show contact detail page" do
    visit page_url
    find(id: dom_id(@contact)).click
    within "#contact-header" do
      assert_text "View Profile"
      assert_text "Message"
      assert_text "Email"
    end
    take_screenshot
  end

  test "can create a new contact" do
    visit page_url
    click_on "Add Contact"
    fill_in "contact_first_name", with: "contact"
    fill_in "contact_last_name", with: "contact"
    fill_in "contact_email", with: "contact@gmail.com"
    fill_in "contact_phone", with: "9050687378"
    click_on "Save"
    take_screenshot
    assert_selector "p.notice", text: "Contact was successfully created."
  end

  test "can not create with empty first_name last_name email phone" do
    visit page_url
    click_on "Add Contact"
    assert_selector "h1", text: "Add New Contact"
    click_on "Save"
    take_screenshot
    assert_selector "h1", text: "Add New Contact"
    assert_selector "div#error_explanation", text: "First name can't be blank"
    assert_selector "div#error_explanation", text: "Last name can't be blank"
    assert_selector "div#error_explanation", text: "Email can't be blank"
    assert_selector "div#error_explanation", text: "Phone can't be blank"
    assert_selector "div#error_explanation", text: "Phone is not a number"
    assert_selector "div#error_explanation", text: "Phone is too short (minimum is 10 characters)"
  end

  test "can edit a contact" do
    visit page_url
    binding.irb
    find(id: dom_id(@contact)).click
    within "#contact-header" do
      click_on "View Profile"
    end
    within "#profile-header" do
      click_on "Edit"
    end
    assert_selector "h1", text: "Edit Contact"
    fill_in "contact_first_name", with: "contact"
    fill_in "contact_last_name", with: "contact1"
    fill_in "contact_phone", with: "9050687378"
    click_on "Save"
    assert_selector "p.notice", text: "Contact was successfully updated."
  end

  test "can not edit a contact with invalid phone" do
    visit page_url
    find(id: dom_id(@contact)).click
    within "#contact-header" do
      click_on "View Profile"
    end
    within "#profile-header" do
      click_on "Edit"
    end
    assert_selector "h1", text: "Edit Contact"
    fill_in "contact_phone", with: "phone"
    click_on "Save"
    take_screenshot
    assert_selector "h1", text: "Edit Contact"
    assert_selector "div#error_explanation", text: "Phone is not a number"
    assert_selector "div#error_explanation", text: "Phone is too short (minimum is 10 characters)"
  end

  test "can archive contact" do
    visit page_url
    find(id: dom_id(@contact)).click
    within "#contact-header" do
      click_on "View Profile"
    end
    within "#profile-header" do
      page.accept_confirm do
        click_on "Archive"
      end
    end
    take_screenshot
    assert_selector "p.notice", text: "Contact has been archived."
  end
end
