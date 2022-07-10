require "application_system_test_case"
require "nokogiri"

class OnboardingTest < ApplicationSystemTestCase
  include ActionMailer::TestHelper

  test "user can login" do
    regular = users(:regular)
    visit new_user_session_path
    fill_in "user_email", with: regular.email
    fill_in "user_password", with: "password"
    click_on "Log In"
    assert_current_path(root_path(script_name: "/#{regular.account.id}"))
    take_screenshot
  end

  test "user can send forgotten password email" do
    regular = users(:regular)
    visit new_user_session_path
    click_on "Forgot your password?"
    fill_in "user_email", with: regular.email

    assert_emails 1 do
      click_on "Send Me Reset Password Instructions"
      sleep(0.5)
    end
    assert_selector "p.notice", text: "You will receive an email with instructions on how to reset your password in a few minutes."
    doc = Nokogiri::HTML::Document.parse(ActionMailer::Base.deliveries.last.body.to_s)
    link = doc.css("a").first.values.first
    visit link
    fill_in "user_password", with: "password"
    fill_in "user_password_confirmation", with: "password"
    click_on "Change My Password"
    assert_selector "p.notice", text: "Your password has been changed successfully."
    take_screenshot
  end

  test "user can signup" do
    visit new_user_registration_path
    fill_in "user_first_name", with: "Aashish"
    fill_in "user_last_name", with: "Dhawan"
    fill_in "user_email", with: "awesome@crownstack.com"
    fill_in "user_password", with: "Awesome@2021!"
    fill_in "user_password_confirmation", with: "Awesome@2021!"
    assert_emails 1 do
      within "#sign_up_form" do
        click_on "Sign Up"
      end
      sleep(4.0)
    end
    take_screenshot
    assert_selector "p.notice", text: "A message with a confirmation link has been sent to your email address. Please follow the link to activate your account."
    doc = Nokogiri::HTML::Document.parse(ActionMailer::Base.deliveries.last.to_s)
    link = doc.css("a").first.values.first
    visit link
    assert_selector "p.notice", text: "Your email address has been successfully confirmed."
    fill_in "user_email", with: "awesome@crownstack.com"
    fill_in "user_password", with: "Awesome@2021!"
    click_on "Log In"
    assert_selector "p.notice", text: "Signed in successfully."
  end

  test "user can not signup with invalid params" do
    visit new_user_registration_path
    within "#sign_up_form" do
      click_on "Sign Up"
    end
    assert_selector "div#error_explanation", text: "First name can't be blank"
    assert_selector "div#error_explanation", text: "Last name can't be blank"
    assert_selector "div#error_explanation", text: "Email can't be blank"
    assert_selector "div#error_explanation", text: "Password can't be blank"
    assert_selector "div#error_explanation", text: "Password is too short (minimum is 6 characters)"
    assert_selector "div#error_explanation", text: "Password confirmation can't be blank"
  end

  test "user can not signup with duplicate email" do
    visit new_user_registration_path
    fill_in "user_email", with: users(:regular).email
    within "#sign_up_form" do
      click_on "Sign Up"
    end
    assert_selector "div#error_explanation", text: "Email has already been taken"
  end

  test "user can confirm email" do
    visit new_user_session_path
    click_on "Didn't receive email confirmation instructions?"
    fill_in "user_email", with: users(:unconfirmed).email
    assert_emails 1 do
      click_on "Resend Confirmation Instructions"
      sleep(0.5)
    end
    take_screenshot

    assert_selector "p.notice", text: "You will receive an email with instructions for how to confirm your email address in a few minutes."
    doc = Nokogiri::HTML::Document.parse(ActionMailer::Base.deliveries.last.to_s)
    link = doc.css("a").first.values.first
    visit link
    assert_selector "p.notice", text: "Your email address has been successfully confirmed."
  end
end
