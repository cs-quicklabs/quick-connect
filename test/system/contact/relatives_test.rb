require "application_system_test_case"

class ContactRelativesTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    ActsAsTenant.current_tenant = @account
    @contact = contacts(:one)
    sign_in @user
  end

  def page_url
    contact_relatives_url(script_name: "/#{@account.id}", contact_id: @contact.id)
  end

  test "can visit index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "#{@contact.first_name} #{@contact.last_name}"
    assert_text "Relations"
  end

  test "can not visit index if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can not add an empty relation" do
    visit page_url
    fill_in "search-contacts", with: "Co"
    first("#add-relation").click
    assert_text "Select Contact Two's relation"
    click_on "Add Relation"
    assert_selector "div#error_explanation", text: "Relation must exist"
    take_screenshot
  end

  test "can add relation" do
    visit page_url
    relation = relations(:father).name
    fill_in "search-contacts", with: "Co"
    first("#add-relation").click
    assert_text "Select Contact Two's relation"
    select relations(:mother).name, from: "relative_relation_id"
    click_on "Add Relation"
    within "#relatives" do
      assert_text "Contact Two"
      assert_text relation
    end
  end

  test "can edit a relation" do
    visit page_url
    relation = Relative.includes(:contact).where("first_contact_id=?", @contact.id).first
    within "#relatives" do
      assert_text relation.contact.decorate.display_name
      find(id: dom_id(relation)).click_link("Edit")
      take_screenshot
      select relations(:mother).name, from: "relative_relation_id"
      click_on "Edit Relation"
      take_screenshot
      assert_no_text "Edit Relation"
      assert_selector "##{dom_id(relation)}", text: "Mother"
    end
  end

  test "can delete a relation" do
    visit page_url
    relative = Relative.includes(:contact).where("first_contact_id=?", @contact.id).first
    within "#relatives" do
      assert_text relative.contact.decorate.display_name
      page.accept_confirm do
        find("turbo-frame", id: dom_id(relative)).click_link("Delete")
      end
      assert_no_text relative.contact.decorate.display_name
    end
    take_screenshot
  end
end
