require "application_system_test_case"

class ContactDebtsTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    ActsAsTenant.current_tenant = @account
    @contact = contacts(:one)
    sign_in @user
  end

  def page_url
    contact_debts_url(script_name: "/#{@account.id}", contact_id: @contact.id)
  end

  test "can visit index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "#{@contact.first_name} #{@contact.last_name}"
    assert_text "Debts"
  end

  test "can not visit index if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can add debt" do
    visit page_url
    fill_in "debt_title", with: "Debt Title"
    select @contact.decorate.display_name, from: "debt_owed_by"
    fill_in "debt_amount", with: "Rs 5"
    fill_in "debt_due_date", with: Date.today
    click_on "Add Debt"
    assert_selector "tbody#debts", text: "Debt Title"
  end

  test "can not add an empty debt" do
    visit page_url
    click_on "Add Debt"
    assert_selector "div#error_explanation", text: "Title can't be blank"
    assert_selector "div#error_explanation", text: "Amount can't be blank"
    take_screenshot
  end

  test "can edit a debt" do
    visit page_url
    debt = @contact.debts.first
    assert_text debt.title
    find("tr", id: dom_id(debt)).click_link("Edit")
    take_screenshot
    fill_in "debt_title", with: "Debt Title Edited"
    select @contact.decorate.display_name, from: "debt_owed_by"
    fill_in "debt_amount", with: "Rs 5 edited"
    fill_in "debt_due_date", with: Date.today
    click_on "Edit Debt"
    assert_no_text "Edit Debt"
    take_screenshot
    assert_selector "##{dom_id(debt)}", text: "Debt Title Edited"
  end

  test "can delete a debt" do
    visit page_url
    debt = @contact.debts.first
    page.accept_confirm do
      find("tr", id: dom_id(debt)).click_link("Delete")
    end
    assert_no_text debt.title
    take_screenshot
  end
end
