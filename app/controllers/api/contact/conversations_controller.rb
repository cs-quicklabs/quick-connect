class Api::Contact::ConversationsController < Api::Contact::BaseController
  before_action :set_conversation, only: %i[ show edit update destroy ]

  def index
    authorize [:api, @contact, Conversation]

    @conversation = Conversation.new
    @pagy, @conversations = pagy_nil_safe(params, @contact.conversations.order(created_at: :desc), items: LIMIT)
    render json: { success: true, data: @conversations.as_json(:include => :field), message: "Conversations fetched successfully" }
  end

  def destroy
    authorize [:api, @contact, @conversation]

    @conversation.destroy
    Event.where(trackable: @conversation).touch_all #fixes cache issues in activity
    respond_to do |format|
      format.json { render json: { success: true, data: @conversation, message: "Conversation deleted successfully" } }
    end
  end

  def edit
    authorize [:api, @contact, @conversation]
    render json: { success: true, data: @conversation, message: "Edit Conversation" }
  end

  def update
    authorize [:api, @contact, @conversation]

    respond_to do |format|
      if @conversation.update(conversation_params)
        format.json { render json: { success: true, data: @conversation, message: "Conversation updated successfully" } }
      else
        format.json { render json: { success: false, message: @conversation.errors.full_messages.first } }
      end
    end
  end

  def create
    authorize [:api, @contact, Conversation]

    @conversation = AddConversation.call(conversation_params, @api_user, @contact).result
    respond_to do |format|
      if @conversation.persisted?
        format.json { render json: { success: true, data: @conversation, message: "Conversation created successfully" } }
      else
        format.json { render json: { success: false, message: @conversation.errors.full_messages.first } }
      end
    end
  end

  private

  def set_conversation
    @conversation = Conversation.find(params["id"])
  end

  def conversation_params
    params.require(:api_conversation).permit(:body, :date, :field_id)
  end
end
