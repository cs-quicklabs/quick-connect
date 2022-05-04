require "application_system_test_case"

class RelativesTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    sign_in @user
  end

  def page_url
    account_relatives_url(script_name: "/#{@account.id}")
  end

  test "can visit the index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "Relatives"
  end

  test "redirect to login if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can add a new relative" do
    visit page_url
    fill_in "Add New Relative", with: "New Relative"
    click_on "Save"
    take_screenshot
    assert_text "Relative was created successfully."
    assert_selector "#relative_name", text: ""
  end

  test "can not add an empty relative" do
    visit page_url
    click_on "Save"
    take_screenshot
    assert_text "Name can't be blank"
  end

  test "can not add a duplicate relative" do
    visit page_url
    fill_in "Add New Relative", with: relatives(:father).name
    click_on "Save"
    take_screenshot
    assert_text "Name has already been taken"
  end

  test "can visit edit page" do
    visit edit_account_relative_url(relatives(:father), script_name: "/#{@account.id}")
    page.assert_selector(:xpath, "/html/body/main/turbo-frame/form/li")
  end

  test "can delete a relative" do
    visit page_url
    relative = relatives(:father)

    assert_selector "li", text: relative.name
    page.accept_confirm do
      find("li", text: relative.name).click_on("Delete")
    end
    assert_no_selector "li", text: relative.name
  end

  test "can edit relative" do
    visit page_url
    relative = relatives(:mother)

    assert_selector "li", text: relative.name
    find("li", text: relative.name).click_on("Edit")
    within "turbo-frame#relative_#{relative.id}" do
      fill_in "relative_name", with: "Edited Name"
      click_on "Save"
    end
    assert_selector "li", text: "Edited Name"
  end

  test "should have nav bar" do
    visit page_url
    assert_selector "#menubar", count: 1
  end

  test "should have left menu with relatives selected" do
    visit page_url
    within "#menu" do
      assert_selector ".selected", text: "Relatives"
    end
  end

  test "can not edit relative with exiting name" do
    visit page_url
    relative = relatives(:mother)
    father = relatives(:father)

    assert_selector "li", text: relative.name
    find("li", text: relative.name).click_on("Edit")
    within "turbo-frame#relative_#{relative.id}" do
      fill_in "relative_name", with: ""
      fill_in "relative_name", with: father.name
      click_on "Save"
      take_screenshot
      assert_text "Name has already been taken"
    end
  end

  test "can not delete a relative which is being used" do
    visit page_url
    relative = relatives(:father)
    assert_selector "li", text: relative.name
    page.accept_confirm do
      find("li", text: relative.name).click_on("Delete")
    end
    take_screenshot
    assert_text "Unable to Delete Record"
    click_on "Cancel"
    assert_no_text "Unable to Delete Record"
    assert_selector "li", text: relative.name
  end
end
