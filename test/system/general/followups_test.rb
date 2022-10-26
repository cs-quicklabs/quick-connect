require "application_system_test_case"

class FollowupsTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    ActsAsTenant.current_tenant = @account
    sign_in @user
    @followups = Contact.all.available.tracked.joins("INNER JOIN events ON contacts.id = events.eventable_id").select("contacts.*, events.created_at as event_create, events.action as event_action, events.trackable_id as event_track, events.trackable_type as event_type").where("events.action IN (?)", ["phone_call", "conversation", "contact_activity", "contact_event"]).where("events.trackable_id IS NOT NULL").order("events.created_at DESC").uniq
  end

  def page_url
    followups_url(script_name: "/#{@account.id}")
  end

  test "can show index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "Follow Ups"
  end

  test "can not show index if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "followup are shown in correct sections" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "Follow Ups"
    @firsts = []
    @seconds = []
    @thirds = []
    @fourths = []
    @followups.each do |followup|
      if Date.today >= followup.event_create.to_date && followup.event_create.to_date >= Date.today - 30.days
        @firsts += [followup]
      elsif Date.today - followup.event_create.to_date && followup.event_create.to_date >= Date.today - 60.days
        @seconds += [followup]
      elsif Date.today - 60.days > followup.event_create.to_date && followup.event_create.to_date >= Date.today - 90.days
        @thirds += [followup]
      else
        @fourths += [followup]
      end
    end
    @firsts.each do |first|
      assert_selector "#firsts", text: first.decorate.display_name
    end
    @seconds.each do |second|
      assert_selector "#seconds", text: second.decorate.display_name
    end
    @thirds.each do |third|
      assert_selector "#thirds", text: third.decorate.display_name
    end
    @fourths.each do |fourth|
      assert_selector "#fourths", text: fourth.decorate.display_name
    end
  end

  test "user should be able to stop tracking contact" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "Follow Ups"
    contact = @followups.last
    within "#contact_#{contact.id}" do
      page.accept_confirm do
        find(id: "untrack").click
      end
      sleep(0.5)
      take_screenshot
    end
    assert_no_selector "li#contact_#{contact.id}"
  end

  test "user should be able to track untracked contact" do
    visit untracked_contacts_url(script_name: "/#{@account.id}")
    contact = contacts(:untracked)
    within "tr#contact_#{contact.id}" do
      page.accept_confirm do
        click_on "Track"
      end
    end
    take_screenshot
    assert_selector "p.notice", text: "Contact has been tracked."
  end
end
