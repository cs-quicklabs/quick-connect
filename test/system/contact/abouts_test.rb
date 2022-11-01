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
    contact_about_index_path_url(script_name: "/#{@account.id}", contact_id: @contact.id)
  end

  test "can visit contatcts about if logged in" do
    visit page_url
    assert_selector "h1", text: "#{@contact.decorate.display_name}"
    assert_text "About"
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
          click_on("Delete")
        end
        assert_text "-"
      end
    end
    take_screenshot
  end
end
