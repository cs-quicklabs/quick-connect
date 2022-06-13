class AddCommentOnJournal < Patterns::Service
  def initialize(params, journal, actor)
    @comment = Comment.new(params)
    @journal = journal
    @actor = actor
  end

  def call
    begin
      add_comment
      add_event
    rescue
      comment
    end
    comment
  end

  private

  def add_comment
    comment.journal = journal
    comment.user = actor
    comment.save!
  end

  def send_email
    return unless report.reportable_type == "User"
    CommentsMailer.with(actor: actor, employee: employee, report: report).commented_email.deliver_later if deliver_email?
  end

  def add_event
    journal.events.create(user: actor, action: "commented", action_for_context: "added a comment for journal", trackable: comment)
  end

  def deliver_email?
    (actor != employee) and employee.email_enabled and employee.account.email_enabled
  end

  attr_reader :journal, :comment, :actor
end
