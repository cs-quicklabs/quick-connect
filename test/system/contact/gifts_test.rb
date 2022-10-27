require "application_system_test_case"

class ContactGiftsTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    ActsAsTenant.current_tenant = @account
    @contact = contacts(:one)
    sign_in @user
  end

  def page_url
    contact_gifts_url(script_name: "/#{@account.id}", contact_id: @contact.id)
  end

  test "can visit index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "#{@contact.first_name} #{@contact.last_name}"
    assert_text "Gifts"
  end

  test "can not visit index if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can add gift" do
    visit page_url
    fill_in "gift_name", with: "Gift Title"
    choose(option: "received")
    fill_in "gift_body", with: "Rs 5"
    fill_in "gift_date", with: Date.today
    click_on "Add Gift"
    assert_selector "tbody#gifts", text: "Gift Title"
  end

  test "can not add an empty gift" do
    visit page_url
    click_on "Add Gift"
    assert_selector "div#error_explanation", text: "Name can't be blank"
    assert_selector "div#error_explanation", text: "Description can't be blank"
    take_screenshot
  end

  test "can edit a gift" do
    visit page_url
    gift = @contact.gifts.first
    assert_text gift.name
    find("tr", id: dom_id(gift)).click_link("Edit")
    take_screenshot
    fill_in "gift_name", with: "Gift Title Edited"
    choose(option: "given")
    fill_in "gift_body", with: "Rs 5 edited"
    fill_in "gift_date", with: Date.today
    click_on "Edit Gift"
    assert_no_text "Edit Gift"
    take_screenshot
    assert_selector "##{dom_id(gift)}", text: "Gift Title Edited"
  end

  test "can delete a gift" do
    visit page_url
    gift = @contact.gifts.first
    page.accept_confirm do
      find("tr", id: dom_id(gift)).click_link("Delete")
    end
    assert_no_text gift.name
    take_screenshot
  end
end
