require "application_system_test_case"

class RelationsTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    sign_in @user
  end

  def page_url
    account_relations_url(script_name: "/#{@account.id}")
  end

  test "can visit the index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "Relations"
  end

  test "redirect to login if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can add a new relation" do
    visit page_url
    fill_in "Add New Relation", with: "New Relation"
    click_on "Save"
    take_screenshot
    assert_text "Relation was created successfully."
    assert_selector "#relation_name", text: ""
  end

  test "can not add an empty relation" do
    visit page_url
    click_on "Save"
    take_screenshot
    assert_text "Name can't be blank"
  end

  test "can not add a duplicate relation" do
    visit page_url
    fill_in "Add New Relation", with: relations(:father).name
    click_on "Save"
    take_screenshot
    assert_text "Name has already been taken"
  end

  test "can visit edit page" do
    visit edit_account_relation_url(relations(:father), script_name: "/#{@account.id}")
    page.assert_selector(:xpath, "/html/body/main/turbo-frame/form/li")
  end

  test "can delete a relation" do
    visit page_url
    relation = relations(:sister)

    assert_selector "li", text: relation.name
    page.accept_confirm do
      find("li", text: relation.name).click_on("Delete")
    end
    assert_no_selector "li", text: relation.name
  end

  test "can edit relation" do
    visit page_url
    relation = relations(:mother)

    assert_selector "li", text: relation.name
    find("li", text: relation.name).click_on("Edit")
    within "turbo-frame#relation_#{relation.id}" do
      fill_in "relation_name", with: "Edited Name"
      click_on "Save"
    end
    assert_selector "li", text: "Edited Name"
  end

  test "should have nav bar" do
    visit page_url
    assert_selector "#menubar", count: 1
  end

  test "should have left menu with relations selected" do
    visit page_url
    within "#menu" do
      assert_selector ".selected", text: "Relations"
    end
  end

  test "can not edit relation with exiting name" do
    visit page_url
    relation = relations(:mother)
    father = relations(:father)

    assert_selector "li", text: relation.name
    find("li", text: relation.name).click_on("Edit")
    within "turbo-frame#relation_#{relation.id}" do
      fill_in "relation_name", with: ""
      fill_in "relation_name", with: father.name
      click_on "Save"
      take_screenshot
      assert_text "Name has already been taken"
    end
  end

  test "can not delete a relation which is being used" do
    visit page_url
    relation = relations(:mother)
    assert_selector "li", text: relation.name
    page.accept_confirm do
      find("li", text: relation.name).click_on("Delete")
    end
    take_screenshot
    assert_text "Unable to Delete Record"
    click_on "Cancel"
    assert_no_text "Unable to Delete Record"
    assert_selector "li", text: relation.name
  end
end
