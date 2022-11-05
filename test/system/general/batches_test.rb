require "application_system_test_case"

class BatchesTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    ActsAsTenant.current_tenant = @account
    @batch = batches(:one)
    sign_in @user
  end

  def page_url
    batches_url(script_name: "/#{@account.id}")
  end

  test "can show index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "Groups"
    assert_text "Add New Group"
  end

  test "can not show index if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can show batch detail page" do
    visit page_url
    find("p", text: @batch.name).click
    within "#show1" do
      assert_selector "h1", text: @batch.name
      assert_text "Search To Add Contact"
      take_screenshot
    end
  end

  test "can create a new batch" do
    visit page_url
    fill_in "batch_name", with: "Badminton"
    click_on "Add"
    take_screenshot
    assert text "Group was successfully created."
  end

  test "can not create with empty name " do
    visit page_url
    click_on "Add"
    assert text "Add New Group"
    click_on "Add"
    take_screenshot
    assert_selector "div#error_explanation", text: "Name can't be blank"
  end

  test "can edit a batch" do
    visit page_url
    find("li", text: @batch.name).click_on("Edit")
    within "turbo-frame#batch_#{@batch.id}" do
      assert text "Edit Group"
      fill_in "batch_name", with: "Bad"
      click_on "Add"
    end
    assert text "Group was successfully updated"
  end

  test "can not edit a batch with existing name" do
    visit page_url
    find("li", text: @batch.name).click_on("Edit")
    group = batches(:group)
    within "turbo-frame#batch_#{@batch.id}" do
      assert text "Edit Group"
      fill_in "batch_name", with: group.name
      click_on "Add"
    end
    take_screenshot
    assert text "Edit Group"
  end

  test "can delete a  batch" do
    visit page_url
    assert_selector "li", text: @batch.name
    page.accept_confirm do
      find("li", text: @batch.name).click_on("Delete")
    end
    assert_no_selector "li", text: @batch.name
  end

  test "can add contact to batch" do
    visit page_url
    find("p", text: @batch.name).click
    within "#show1" do
      assert text @batch.name.titleize
      fill_in "search", with: "Co"
      within "#searched_contacts" do
        first("#batch-contact").click
      end
      sleep(0.5)
      within "ul#batch_contacts" do
        assert text "Contact Contact"
      end
    end
    take_screenshot
  end

  test "can remove contact from batch" do
    visit page_url
    find("p", text: @batch.name).click
    within "#show1" do
      assert_selector "h1", text: @batch.name
      within "ul#batch_contacts" do
        assert text "Contact Contact"
        page.accept_confirm do
          find("li", id: dom_id(@batch.contacts.first)).click_on("Delete")
        end
        assert_no_text "Contact Contact"
      end
    end
    take_screenshot
  end

  test "can view profile of any contact on adding" do
    visit page_url
    find("p", text: @batch.name).click
    within "#show1" do
      assert_selector "h1", text: @batch.name
      fill_in "search", with: "Co"
      within "#searched_contacts" do
        first("#batch-contact").click
      end
      sleep(0.5)
      within "ul#batch_contacts" do
        find("li", text: "Contact Contact").click
      end
    end
    assert_selector "#profile", text: "Contact Contact"
    take_screenshot
  end
end
