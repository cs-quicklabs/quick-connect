require "application_system_test_case"

class ExportTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    sign_in @user
  end

  def page_url
    account_export_contacts_path(script_name: "/#{@account.id}")
  end

  test "can visit the index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "Export Contacts"
  end

  test "can export conatacts " do
    visit page_url
    within "#button" do
      click_on "Export Contacts"
    end
    assert_text "Your report has been successfully generated!"
    click_on "Click here to download"
  end
  test "should have nav bar" do
    visit page_url
    assert_selector "#menu", count: 1
  end
  test "should have left menu with export contacts selected" do
    visit page_url
    within "#menu" do
      assert_selector ".selected", text: "Export Contacts"
    end
  end
end
