class Contact::ConversationsController < Contact::BaseController
  before_action :set_conversation, only: %i[ show edit update destroy ]

  def index
    authorize [@contact, Conversation]

    @conversation = Conversation.new
    @pagy, @conversations = pagy_nil_safe(params, @contact.conversations.order(created_at: :desc), items: LIMIT)
    render_partial("conversations/call", collection: @conversations) if stale?(@conversations)
  end

  def destroy
    authorize [@contact, @conversation]
    @conversation = DestroyConversation.call(@contact, current_user, @conversation).result
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@conversation) }
    end
  end

  def edit
    authorize [@contact, @conversation]
  end

  def show
    authorize [@contact, @conversation]
  end

  def update
    authorize [@contact, @conversation]

    respond_to do |format|
      if @conversation.update(conversation_params)
        Event.where(trackable: @conversation).touch_all
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@conversation, partial: "contact/conversations/conversation", locals: { conversation: @conversation }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@conversation, template: "contact/conversations/edit", locals: { conversation: @conversation }) }
      end
    end
  end

  def create
    authorize [@contact, Conversation]

    @conversation = AddConversation.call(conversation_params, current_user, @contact).result
    respond_to do |format|
      if @conversation.persisted?
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:conversations, partial: "contact/conversations/conversation", locals: { conversation: @conversation }) +
                               turbo_stream.replace(Conversation.new, partial: "contact/conversations/form", locals: { conversation: Conversation.new })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Conversation.new, partial: "contact/conversations/form", locals: { conversation: @conversation }) }
      end
    end
  end

  private

  def set_conversation
    @conversation = Conversation.find(params["id"])
  end

  def conversation_params
    params.require(:conversation).permit(:body, :date, :field_id)
  end
end
