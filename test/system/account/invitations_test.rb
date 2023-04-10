require "application_system_test_case"

class InvitationsTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    sign_in @user
  end

  def page_url
    account_invitations_url(script_name: "/#{@account.id}")
  end

  test "can visit the index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "Add New User"
  end

  test "redirect to login if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "should have nav bar" do
    visit page_url
    assert_selector "#menu", count: 1
  end
  test "should have left menu with  users selected" do
    visit page_url
    within "#menu" do
      assert_selector ".selected", text: "Users"
    end
  end

  test "can add a new invitation" do
    visit page_url
    fill_in "invitation_first_name", with: "invite"
    fill_in "invitation_last_name", with: "invite1"
    fill_in "invitation_email", with: "invite2@gmail.com"
    click_on "Save"
    sleep(0.5)
    take_screenshot
    assert_text "Thank you, invitation sent."
    assert_selector "#invitations", text: "Invite Invite1"
    sign_out(@user)
    doc = Nokogiri::HTML::Document.parse(ActionMailer::Base.deliveries.last.to_s)
    link = doc.css("a").first.values.first
    visit link
    fill_in "user_password", with: "password"
    fill_in "user_password_confirmation", with: "password"
    click_on "Set password and login"
    take_screenshot
    assert_selector "p.notice", text: "Your password was set successfully. You are now signed in."
  end

  test "can not add an empty invitation" do
    visit page_url
    click_on "Save"
    take_screenshot
    assert_text "First name can't be blank"
    assert_text "Last name can't be blank"
    assert_text "E-mail is invalid"
  end

  test "can not add a duplicate invitation user email" do
    visit page_url
    user = users(:actor)
    fill_in "invitation_first_name", with: "invite"
    fill_in "invitation_last_name", with: "invite"
    fill_in "invitation_email", with: user.email
    click_on "Save"
    take_screenshot
    assert_text "E-mail is already registered"
  end
  test "can not add a duplicate invite  email" do
    visit page_url
    invitation = invitations(:one)
    fill_in "invitation_first_name", with: "invite"
    fill_in "invitation_last_name", with: "invite"
    fill_in "invitation_email", with: invitation.email
    click_on "Save"
    take_screenshot
    assert_text "E-mail has already been taken"
    assert_text "E-mail is already registered"
  end

  test "can deactivate user" do
    visit page_url
    invitation = invitations(:one)
    within "turbo-frame#invitation_#{invitation.id}" do
      page.accept_confirm do
        click_on("Deactivate")
      end
      assert text "Activate"
    end
    sign_out(@user)
    sign_in(invitation.user)
    take_screenshot
    assert text "Sign in to your account"
  end

  test "can activate user" do
    visit page_url
    invitation = invitations(:one)
    within "turbo-frame#invitation_#{invitation.id}" do
      page.accept_confirm do
        find("li", text: invitation.email).click_link("Deactivate")
      end
      assert text "Activate"
    end
    sleep(1.0)
    sign_out(@user)
    doc = Nokogiri::HTML::Document.parse(ActionMailer::Base.deliveries.last.to_s)
    link = doc.css("a").first.values.first
    visit link
    fill_in "user_password", with: "password"
    fill_in "user_password_confirmation", with: "password"
    click_on "Set password and login"
    take_screenshot
    assert_selector "p.notice", text: "Your password was set successfully. You are now signed in."
  end
end
