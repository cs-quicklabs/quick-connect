require "application_system_test_case"

class LabelsTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    sign_in @user
  end

  def page_url
    account_labels_url(script_name: "/#{@account.id}")
  end

  test "can visit the index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "Labels"
  end

  test "redirect to login if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can add a new label" do
    visit page_url
    fill_in "label_name", with: "Initiated"
    choose(option: "green")
    click_on "Save"
    take_screenshot
    assert_text "Label was created successfully"
    assert_selector "#label_name", text: ""
  end

  test "can not add an empty label" do
    visit page_url
    click_on "Save"
    assert_selector "div#error_explanation", text: "Name can't be blank"
    take_screenshot
  end

  test "can visit edit page" do
    visit edit_account_label_url(labels(:one), script_name: "/#{@account.id}")
    page.assert_selector(:xpath, "/html/body/main/turbo-frame/form/div")
  end

  test "can delete a ticket label" do
    visit page_url
    label = labels(:two)
    assert_selector "li", text: label.name
    page.accept_confirm do
      find("li", text: label.name).click_on("Delete")
    end
    assert_no_selector "li", text: label.name
  end

  test "can edit label" do
    visit page_url
    label = labels(:one)
    assert_selector "li", text: label.name
    find("li", text: label.name).click_on("Edit")
    within "turbo-frame#label_#{label.id}" do
      fill_in "label_name", with: "Edited Name"
      click_on "Save"
    end
    assert_selector "li", text: "Edited Name"
  end

  test "should have nav bar" do
    visit page_url
    assert_selector "#menubar", count: 1
  end

  test "should have left menu with  Labels selected" do
    visit page_url
    within "#menu" do
      assert_selector ".selected", text: "Labels"
    end
  end
end
