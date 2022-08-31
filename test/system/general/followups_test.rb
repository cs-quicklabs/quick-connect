require "application_system_test_case"

class BatchesTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    ActsAsTenant.current_tenant = @account
    @followups = Contact.all.available.tracked.joins("INNER JOIN events ON contacts.id = events.eventable_id").select("contacts.*, events.created_at as event_create, events.action as event_action, events.trackable_id as event_track, events.trackable_type as event_type").where("events.action IN (?)", ["phone_call", "conversation", "contact_activity", "contact_event"]).where("events.trackable_id IS NOT NULL").order("events.created_at DESC").uniq
    sign_in @user
  end

  def page_url
    followups_url(script_name: "/#{@account.id}")
  end

  test "can show index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "Follow-ups"
    assert_text "Follow Ups"
  end

  test "can not show index if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "followup are shown in correct sections" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "Follow-ups"
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
  end
end
