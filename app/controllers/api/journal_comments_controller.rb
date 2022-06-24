class Api::JournalCommentsController < Api::BaseController
  before_action :set_comment, only: %i[ update destroy edit ]
  before_action :set_journal, only: %i[ create ]

  def create
    authorize [:api, @journal]
    @comment = AddCommentOnJournal.call(comment_params, @journal, @api_user).result
    respond_to do |format|
      if @comment.persisted?
        format.json { render json: { success: true, data: @comment, message: "Comment was successfully created" } }
      else
        format.json { render json: { success: false, message: @comment.errors.full_messages.first } }
      end
    end
  end

  def edit
    authorize [:api, @comment]
    render json: { success: true, comment: @comment, message: "" }
  end

  def update
    authorize [:api, @comment]

    respond_to do |format|
      if @comment.update(comment_params)
        format.json { render json: { success: true, data: @comment, message: "Comment was successfully updated" } }
      else
        format.json { render json: { success: false, message: @comment.errors.full_messages.first } }
      end
    end
  end

  def destroy
    authorize [:api, @comment]
    @comment.destroy
    respond_to do |format|
      format.json { render json: { success: true, message: "Comment was successfully deleted" } }
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
