class JournalCommentsController < BaseController
  before_action :set_comment, only: %i[ update destroy edit ]
  before_action :set_journal, only: %i[ create ]

  def create
    authorize @journal, :comment?
    @comment = AddCommentOnJournal.call(comment_params, @journal, @current_user).result
    respond_to do |format|
      if @comment.persisted?
        format.turbo_stream {
          render turbo_stream: turbo_stream.append(:comments, partial: "journal_comments/comment", locals: { comment: @comment }) +
                               turbo_stream.replace(:add, partial: "journal_comments/add", locals: { journal: @journal, comment: Comment.new })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(:add, partial: "journal_comments/add", locals: { journal: @journal, comment: @comment }) }
      end
    end
  end

  def edit
    authorize @comment
  end

  def update
    authorize @comment

    respond_to do |format|
      if @comment.update(comment_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@comment, partial: "journal_comments/comment", locals: { comment: @comment }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@comment, template: "journal_comments/edit", locals: { comment: @comment }) }
      end
    end
  end

  def destroy
    authorize @comment
    @comment.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@comment) }
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:title, :journal_id)
  end

  def set_comment
    if @comment
      return @contact_activity
    end
    @comment ||= Comment.find(params["id"])
  end

  def set_journal
    if @journal
      return @journal
    end
    @journal ||= Journal.find(comment_params["journal_id"])
  end
end
