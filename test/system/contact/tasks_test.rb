require "application_system_test_case"

class ContactTasksTest < ApplicationSystemTestCase
  setup do
    @user = users(:regular)
    @account = @user.account
    ActsAsTenant.current_tenant = @account
    sign_in @user
    @contact = contacts(:one)
  end

  def page_url
    contact_tasks_url(script_name: "/#{@account.id}", contact_id: @contact.id)
  end

  test "can visit index page if logged in" do
    visit page_url
    take_screenshot
    assert_selector "h1", text: "#{@contact.first_name} #{@contact.last_name}"
    assert_text "Add New Task"
  end

  test "can not visit index page if not logged in" do
    sign_out @user
    visit page_url
    assert_selector "h1", text: "Sign in to your account"
  end

  test "can see task detail page" do
    visit page_url
    task = @contact.tasks.first
    find("tr", id: dom_id(task)).click_link(task.title)
    assert_selector "h3", text: task.title
    take_screenshot
  end

  test "can add new task" do
    visit page_url
    fill_in "task_title", with: "Some Random Task Title"
    fill_in "task_body", with: "Some Random Task Body"
    fill_in "task_due_date", with: Time.now
    click_on "Add Task"
    assert_selector "tbody#tasks", text: "Some Random Task Title"
    take_screenshot
  end

  test "can check a task" do
    visit page_url
    task = @contact.tasks.first
    find("tr", id: dom_id(task)).check "completed"
    take_screenshot
  end

  test "can not add task with empty params" do
    visit page_url
    click_on "Add Task"
    take_screenshot
    assert_selector "div#error_explanation", text: "Title can't be blank"
  end

  test "can edit a task" do
    visit page_url
    task = @contact.tasks.where(completed: 0).last
    assert_text task.title
    find("tr", id: dom_id(task)).click_link("Edit")
    take_screenshot
    fill_in "task_title", with: "Task Edited"
    click_on "Edit Task"
    take_screenshot
    assert_no_text "Edit Task"
    assert_selector "p.notice", text: "Task was successfully updated."
    assert_selector "##{dom_id(task)}", text: "Task Edited"
  end

  test "can not edit task with invalid params" do
    visit page_url
    task = @contact.tasks.where(completed: 0).first
    assert_text task.title
    find("tr", id: dom_id(task)).click_link("Edit")
    fill_in "task_title", with: ""
    click_on "Edit Task"
    take_screenshot
    assert_selector "div#error_explanation", text: "Title can't be blank"
  end

  test "can delete a task" do
    visit page_url
    task = @contact.tasks.where(completed: 0).first
    display_name = task.contact.decorate.display_name
    assert_text display_name
    page.accept_confirm do
      find("tr", id: dom_id(task)).click_link("Delete")
    end
    assert_no_selector "tbody#tasks", text: task.title
  end

  test "can not show add task when contact is inactive" do
    inactive_contact = contacts(:archived)
    visit contact_tasks_url(script_name: "/#{@account.id}", contact_id: inactive_contact.id)
    assert_no_text "Add New Task"
  end
end
