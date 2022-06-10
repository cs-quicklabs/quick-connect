class Api::JournalCommentsController < Api::BaseController
  before_action :set_comment, only: %i[ update destroy edit ]
  before_action :set_journal, only: %i[ create ]

  def create
    @comment = AddCommentOnJournal.call(comment_params, @journal, @user).result
    respond_to do |format|
      if @comment.persisted?
        format.json { render json: { suceess: true, comment: @comment, message: "" } }
      else
        format.turbo_stream { render json: { suceess: false, comment: @comment, message: @comment.errors.full_messages.join(", ") } }
      end
    end
  end

  def edit
    render json: { suceess: true, comment: @comment, message: "" }
  end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.json { render json: { suceess: true, data: @comment, message: "Comment was successfully updated" } }
      else
        format.json { render json: { suceess: false, data: @comment, message: @comment.errors.full_messages.join(", ") } }
      end
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.json { render json: { suceess: true, data: @comment, message: "Comment was successfully deleted" } }
    end
  end

  private

  def comment_params
    params.require(:api_comment).permit(:title, :journal_id)
  end

  def set_comment
    @comment ||= Comment.find(params["id"])
  end

  def set_journal
    @journal ||= Journal.find(comment_params["journal_id"])
  end
end
