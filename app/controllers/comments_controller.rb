class CommentsController < BaseController
  before_action :set_comment, only: %i[ update destroy edit ]
  before_action :set_journal, only: %i[ create ]

  def create
    authorize Comment

    @comment = AddCommentOnJournal.call(comment_params, @journal, @user).result
    respond_to do |format|
      if @comment.persisted?
        format.turbo_stream {
          render turbo_stream: turbo_stream.append(:comments, partial: "comments/comment", locals: { comment: @comment }) +
                               turbo_stream.replace(:add, partial: "comments/add", locals: { journal: @journal, comment: Comment.new })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(:add, partial: "comments/add", locals: { journal: @journal, comment: @comment }) }
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
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@comment, partial: "comments/comment", locals: { comment: @comment }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@comment, template: "comments/edit", locals: { comment: @comment }) }
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
    params.require(:comment).permit(:title, :user_id, :journal_id)
  end

  def set_comment
    @comment ||= Comment.find(params["id"])
  end

  def set_journal
    @journal ||= Journal.find(comment_params["journal_id"])
  end
end
