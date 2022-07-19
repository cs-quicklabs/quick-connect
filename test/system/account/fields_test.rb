require "application_system_test_case"

class RelationsTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    sign_in @user
  end

  def page_url
    account_fields_url(script_name: "/#{@account.id}")
  end

  test "can visit the index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "Contact Field Type"
  end

  test "redirect to login if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can add a new field" do
    visit page_url
    fill_in "Field Type", with: "New Relation"
    click_on "Save"
    take_screenshot
    assert_text "Field was created successfully."
    assert_selector "#field_name", text: ""
  end

  test "can not add an empty field" do
    visit page_url
    click_on "Save"
    take_screenshot
    assert_text "Name can't be blank"
  end

  test "can not add a duplicate field" do
    visit page_url
    fill_in "Field Type", with: fields(:facebook).name
    click_on "Save"
    take_screenshot
    assert_text "Name has already been taken"
  end

  test "can visit edit page" do
    visit edit_account_field_url(fields(:facebook), script_name: "/#{@account.id}")
    page.assert_selector(:xpath, "/html/body/main/turbo-frame/form/li")
  end

  test "can delete a field" do
    visit page_url
    field = fields(:message)

    assert_selector "li", text: field.name
    page.accept_confirm do
      find("li", text: field.name).click_on("Delete")
    end
    assert_no_selector "li", text: field.name
  end

  test "can edit field" do
    visit page_url
    field = fields(:facebook)

    assert_selector "li", text: field.name
    find("li", text: field.name).click_on("Edit")
    within "turbo-frame#field_#{field.id}" do
      fill_in "field_name", with: "Facebook Messenger"
      click_on "Save"
    end
    assert_selector "li", text: "Facebook Messenger"
  end

  test "should have nav bar" do
    visit page_url
    assert_selector "#menubar", count: 1
  end

  test "should have left menu with fields selected" do
    visit page_url
    within "#menu" do
      assert_selector ".selected", text: "Contact Field Types"
    end
  end

  test "can not edit field with existing name" do
    visit page_url
    field = fields(:email)
    facebook = fields(:facebook)

    assert_selector "li", text: field.name
    find("li", text: field.name).click_on("Edit")
    within "turbo-frame#field_#{field.id}" do
      fill_in "field_name", with: facebook.name
      click_on "Save"
      take_screenshot
      assert_text "Name has already been taken"
    end
  end

  test "can not delete a field which is being used" do
    visit page_url
    field = fields(:email)
    assert_selector "li", text: field.name
    page.accept_confirm do
      find("li", text: field.name).click_on("Delete")
    end
    take_screenshot
    assert_text "Unable to Delete Record"
    click_on "Cancel"
    assert_no_text "Unable to Delete Record"
    assert_selector "li", text: field.name
  end
end
