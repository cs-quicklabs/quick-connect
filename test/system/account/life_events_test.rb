require "application_system_test_case"

class LifeEventsTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    sign_in @user
  end

  def page_url
    account_life_events_url(script_name: "/#{@account.id}")
  end

  test "can visit the index if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "Add New Life Event"
  end

  test "should have left menu with  Life Events selected" do
    visit page_url
    within "#menu" do
      assert_selector ".selected", text: "Life Events"
    end
  end

  test "redirect to login if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can add a new life event" do
    visit page_url
    select groups(:family).name, from: "life_event_group_id"
    fill_in "life_event_name", with: "played a sport together"
    click_on "Save"
    take_screenshot
    assert_text "Life event was created successfully"
    assert_selector "#life_event_name", text: ""
  end

  test "can not add an empty life event" do
    visit page_url
    click_on "Save"
    assert_selector "div#error_explanation", text: "Event name can't be blank"
    take_screenshot
  end

  test "can not add a duplicate life event" do
    visit page_url
    fill_in "life_event_name", with: life_events(:family_one).name
    click_on "Save"
    take_screenshot
    assert_text "Event name has already been taken"
  end

  test "can visit edit page" do
    visit edit_account_life_event_url(life_events(:family_one), script_name: "/#{@account.id}")
    page.assert_selector(:xpath, "/html/body/main/turbo-frame/form/li/div")
  end

  test "can edit life event" do
    visit page_url
    life_event = life_events(:family_one)
    assert_selector "li", text: life_event.name
    find("li", text: life_event.name).click_on("Edit")
    within "turbo-frame#life_event_#{life_event.id}" do
      fill_in "life_event_name", with: "Edited Name"
      click_on "Save"
    end
    assert_selector "li", text: "Edited Name"
  end

  test "can delete a  life event" do
    visit page_url
    life_event = life_events(:family_three)
    assert_selector "li", text: life_event.name
    page.accept_confirm do
      find("li", text: life_event.name).click_on("Delete")
    end
    assert_no_selector "li", text: life_event.name
  end

  test "can not delete a life event" do
    visit page_url
    life_event = life_events(:family_two)
    assert_selector "li", text: life_event.name
    page.accept_confirm do
      find("li", text: life_event.name).click_on("Delete")
    end
    assert_text "Unable to Delete Record"
    click_on "Cancel"
    assert_no_text "Unable to Delete Record"
    assert_selector "li", text: life_event.name
  end

  test "can not edit life event with existing name" do
    visit page_url
    life_event = life_events(:family_one)
    two = life_events(:family_two)
    assert_selector "li", text: life_event.name
    find("li", text: life_event.name).click_on("Edit")
    within "turbo-frame#life_event_#{life_event.id}" do
      fill_in "life_event_name", with: two.name
      click_on "Save"
      take_screenshot
      assert_text "Event name has already been taken"
    end
  end
end
