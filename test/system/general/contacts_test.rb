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

  def contact_page_url
    contact_about_index_url(script_name: "/#{@account.id}", contact_id: @contact.id)
  end

  def edit_contact_page_url
    edit_contact_url(script_name: "/#{@account.id}", id: @contact.id)
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
    find("li", id: dom_id(@contact)).click
    assert_selector "h1", text: @contact.decorate.display_name
    take_screenshot
  end

  test "can create a new contact" do
    visit page_url
    click_on "Add Contact"
    fill_in "contact_first_name", with: "contact"
    fill_in "contact_last_name", with: "contact"
    fill_in "contact_email", with: "contact8@gmail.com"
    fill_in "contact_phone", with: "9050687378"
    click_on "Save"
    take_screenshot
    assert_selector "p.notice", text: "Contact was successfully created."
  end

  test "can create a new contact save and add more" do
    visit page_url
    click_on "Add Contact"
    fill_in "contact_first_name", with: "contact"
    fill_in "contact_last_name", with: "contact"
    fill_in "contact_email", with: "contact8@gmail.com"
    fill_in "contact_phone", with: "9050687378"
    click_on "Save And Add More"
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
    assert_selector "div#error_explanation", text: "Phone number or E-mail can't be blank"
    assert_selector "h1", text: "Add New Contact"
  end

  test "can not create with empty first_name last_name email phone save and add more" do
    visit page_url
    click_on "Add Contact"
    assert_selector "h1", text: "Add New Contact"
    click_on "Save And Add More"
    take_screenshot
    assert_selector "h1", text: "Add New Contact"
    assert_selector "div#error_explanation", text: "First name can't be blank"
    assert_selector "div#error_explanation", text: "Last name can't be blank"
    assert_selector "div#error_explanation", text: "Phone number or E-mail can't be blank"
  end

  test "can edit a contact" do
    visit page_url
    find("li", id: dom_id(@contact)).click
    assert_selector "h1", text: @contact.decorate.display_name
    within "#contact-header" do
      find('label[for="profile"]').click
    end
    within "#contact-header" do
      find('label[for="edit"]').click
    end
    assert_selector "h1", text: "Edit Contact"
    fill_in "contact_first_name", with: "contact"
    fill_in "contact_last_name", with: "contact1"
    fill_in "contact_phone", with: "9050687378"
    click_on "Save"
    assert_selector "p.notice", text: "Contact was successfully updated."
  end

  test "can edit a contact save and add more" do
    visit page_url
    find("li", id: dom_id(@contact)).click
    assert_selector "h1", text: @contact.decorate.display_name
    within "#contact-header" do
      find('label[for="profile"]').click
    end
    within "#contact-header" do
      find('label[for="edit"]').click
    end
    assert_selector "h1", text: "Edit Contact"
    fill_in "contact_first_name", with: "contact"
    fill_in "contact_last_name", with: "contact1"
    fill_in "contact_phone", with: "9050687378"
    click_on "Save And Add More"
    assert_selector "p.notice", text: "Contact was successfully updated."
    assert_selector "h1", text: "Add New Contact"
  end

  test "can not edit a contact with invalid phone email" do
    visit page_url
    find("li", id: dom_id(@contact)).click
    assert_selector "h1", text: @contact.decorate.display_name
    within "#contact-header" do
      find('label[for="profile"]').click
    end
    within "#contact-header" do
      find('label[for="edit"]').click
    end
    assert_selector "h1", text: "Edit Contact"
    fill_in "contact_phone", with: "phone"
    click_on "Save"
    take_screenshot
    assert_selector "h1", text: "Edit Contact"
    assert_selector "div#error_explanation", text: "Phone number is invalid"
  end

  test "can not edit a contact with invalid phone save and add more" do
    visit page_url
    find("li", id: dom_id(@contact)).click
    assert_selector "h1", text: @contact.decorate.display_name
    within "#contact-header" do
      find('label[for="profile"]').click
    end
    within "#contact-header" do
      find('label[for="edit"]').click
    end
    assert_selector "h1", text: "Edit Contact"
    fill_in "contact_phone", with: "phone"
    click_on "Save And Add More"
    take_screenshot
    assert_selector "h1", text: "Edit Contact"
    assert_selector "div#error_explanation", text: "Phone number is invalid"
  end

  test "can add label" do
    visit page_url
    find("li", id: dom_id(@contact)).click
    assert_selector "h1", text: @contact.decorate.display_name
    within "#contact-header" do
      find('label[for="profile"]').click
    end
    within "#contact-header" do
      click_on "add"
    end
    take_screenshot
    click_on Label.first.name
    assert_selector "span", text: Label.first.name
    take_screenshot
    find("div", id: "contact-labels").click_button("remove")
    assert_no_selector "span", text: Label.first.name
    take_screenshot
  end

  test "can add as favorite" do
    visit page_url
    find("li", id: dom_id(@contact)).click
    assert_selector "h1", text: @contact.decorate.display_name
    favorite = !@contact.favorite
    within "#contact-header" do
      find('label[for="profile"]').click
    end
    within "#contact-header" do
      find("div", id: "contact-favorite").click
      assert_selector "#favorite"
    end
    take_screenshot
  end

  test "can archive contact" do
    visit page_url
    find("li", id: dom_id(@contact)).click
    assert_selector "h1", text: @contact.decorate.display_name
    within "#contact-header" do
      find('label[for="profile"]').click
    end
    within "#contact-header" do
      page.accept_confirm do
        click_on "Archive"
      end
    end
    take_screenshot
    assert_selector "p.notice", text: "Contact has been archived."
  end

  test "can activate an contact" do
    visit archived_contacts_url(script_name: "/#{@account.id}")
    contact = contacts(:archived)
    click_on "#{contact.first_name} #{contact.last_name}"
    within "#contact-header" do
      page.accept_confirm do
        click_on "Restore"
      end
    end
    take_screenshot
    assert_selector "p.notice", text: "Contact has been restored."
  end

  test "can see archived users and restore" do
    visit archived_contacts_url(script_name: "/#{@account.id}")
    page.first(:link, "Restore").click
    assert_selector "p.notice", text: "Contact has been restored."
  end
end
