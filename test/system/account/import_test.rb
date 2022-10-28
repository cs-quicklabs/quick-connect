require "application_system_test_case"

class ImportTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    sign_in @user
  end

  def page_url
    account_import_contacts_path(script_name: "/#{@account.id}")
  end

  test "can visit the index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "Import Contacts"
  end
  test "should have nav bar" do
    visit page_url
    assert_selector "#menu", count: 1
  end
  test "should have left menu with  import contacts selected" do
    visit page_url
    within "#menu" do
      assert_selector ".selected", text: "Import Contacts"
    end
  end
end
