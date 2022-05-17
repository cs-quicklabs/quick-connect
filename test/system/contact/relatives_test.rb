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
    sign_out @contact
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can add relation" do
    visit page_url
    relation = relations(:father).name
    fill_in "search-contacts", with: "Co"
    binding.irb
    find("#add-contact").click
    assert_selector "#contact-contacts", text: "Select Contact Contact1's relation"
    select relation from "#relative_relation_id"
    click_on "Add Relation"
    within "#relations" do
      assert_text "Contact Contact1"
      assert_text relation
    end
  end
  test "can edit a relation" do
    visit page_url
    relation = @contact.relatives.first
    mother = relations(:mother).name
    assert_text relation.contact.decorate.display_name
    find("tr", id: dom_id(relation)).click_link("Edit")
    take_screenshot
    select relation from "#relative_relation_id"
    click_on "Edit Relation"
    take_screenshot
    assert_no_text "Edit Relation"
    assert_selector "p.notice", text: "Relation was successfully updated."
    assert_selector "li##{dom_id(relation)}", text: "Mother"
  end

  test "can delete a relation" do
    visit page_url
    relative = @contact.relatives.first
    assert_text relative.contact.decorate.display_name
    page.accept_confirm do
      find("turbo-frame", id: dom_id(relative)).click_link("Delete")
    end
    assert_no_text relative.contact.decorate.display_name
    take_screenshot
  end
end
