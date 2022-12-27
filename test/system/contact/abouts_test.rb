require "application_system_test_case"

class ContactAboutsTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    ActsAsTenant.current_tenant = @account
    sign_in @user
    @contact = contacts(:one)
  end

  def page_url
    contact_about_index_url(script_name: "/#{@account.id}", contact_id: @contact.id)
  end

  test "can visit contatcts about if logged in" do
    visit page_url
    assert_selector "h1", text: "#{@contact.decorate.display_name}"
    assert_text "About"
    assert_text "Address"
    assert_text "Add Social Profile Links"
  end

  test "can edit the contact about" do
    visit page_url
    about = @contact.abouts.slice(:address, :breif, :met, :habit, :work, :other)

    about.each do |key, value|
      frame_id = dom_id(@contact.abouts, key + "_turbo_frame")
      within "##{frame_id}" do
        click_on("Update")
        fill_in "about_#{key}", with: "This is test about the contact"
        click_on "Save"
        sleep(0.5)
        assert_text "This is test about the contact"
      end
    end
    take_screenshot
  end

  test "can not visit contact about if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can edit the contact delete" do
    visit page_url
    about = @contact.abouts.slice(:address, :breif, :met, :habit, :work, :other)
    about.each do |key, value|
      frame_id = dom_id(@contact.abouts, key + "_turbo_frame")
      within "##{frame_id}" do
        page.accept_confirm do
          click_on("Clear")
        end
        assert_text "-"
      end
    end
    take_screenshot
  end

  test "can add a social media link" do
    visit page_url
    select "Youtube", from: "link_link_type"
    fill_in "link_link", with: "youtube.com"
    click_on "Save"
    within "#contact_links" do
      assert_text "Youtube"
      assert_text "youtube.com"
    end
    take_screenshot
  end

  test "can not add an empty social media link " do
    visit page_url
    click_on "Save"
    assert_selector "div#error_explanation", text: "Link can't be blank"
    take_screenshot
  end

  test "can not add an invalid social media link " do
    visit page_url
    select "LinkedIn", from: "link_link_type"
    fill_in "link_link", with: "linkedin.com"
    click_on "Save"
    assert_selector "div#error_explanation", text: "Profile already exists"
    take_screenshot
  end

  test "can delete a social media link" do
    visit page_url
    link = @contact.links.first
    assert_text link.link_type.split("-").last.upcase_first
    page.accept_confirm do
      find("turbo-frame", id: dom_id(link)).click_link("Delete")
    end
    assert_no_text link.link_type.split("-").last
    take_screenshot
  end

  test "can edit a social media link" do
    visit page_url
    link = @contact.links.first
    assert_text link.link_type.split("-").last.upcase_first
    find("turbo-frame", id: dom_id(link)).click_link("Edit")
    within "#contact_links" do
      fill_in "link_link", with: "linkedin.com1"
      click_on "Save"
      take_screenshot
      assert_no_text "Edit Link"
    end
    assert_selector "##{dom_id(link)}", text: "linkedin.com1"
  end

  test "can not edit social link with invalid params" do
    visit page_url
    link = @contact.links.first
    assert_text link.link_type.split("-").last.upcase_first
    find("turbo-frame", id: dom_id(link)).click_link("Edit")
    within "#contact_links" do
      fill_in "link_link", with: ""
      click_on "Save"
      take_screenshot
      assert_selector "div#error_explanation", text: "Link can't be blank"
    end
  end
end
