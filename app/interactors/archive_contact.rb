class ArchiveContact < Patterns::Service
  def initialize(contact, actor)
    @contact = contact
    @actor = actor
  end

  def call
    begin
      archive
      add_event
    rescue
      contact
    end
    contact
  end

  private

  def clear_schedule
    contact.schedules.destroy_all
    contact.billable_resources = 0.0
  end

  def archive
    contact.archived = true
    contact.archived_on = DateTime.now.utc
    contact.save!
  end

  def clear_todos
    contact.todos.pending.destroy_all
  end

  def discard_milestones
    contact.milestones.where(status: :progress).each do |goal|
      params = { user_id: actor.id, commentable_id: goal.id, title: "Discarding as contact has been archived.", status: "stale" }
      goal.comments << Comment.new(params)
      goal.update_attribute("status", "discarded")
    end
  end

  def submit_pending_reports
    contact.reports.update_all(submitted: true)
  end

  def add_event
    contact.events.create(user: actor, action: "archived", action_for_context: "archived contact", trackable: contact, action_context: "archived")
  end

  attr_reader :contact, :actor
end
