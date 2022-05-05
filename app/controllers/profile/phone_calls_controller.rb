class Profile::PhoneCallsController < Profile::BaseController
    before_action :set_phone_call, only: %i[ show edit update destroy] 
    
      def index
        authorize [@contact, PhoneCall]
    
        @phone_call = PhoneCall.new
        @pagy, @phone_calls = pagy_nil_safe(params, @contact.phone_calls.order(created_at: :desc), items: LIMIT)
        render_partial("phone_calls/call", collection: @phone_calls) if stale?(@phone_calls)
      end
    
      def destroy
        authorize [@contact, @phone_call]
    
        @phone_call.destroy
        Event.where(trackable: @phone).touch_all #fixes cache issues in activity
        respond_to do |format|
          format.turbo_stream { render turbo_stream: turbo_stream.remove(@call) }
        end
      end
    
      def edit
        authorize [@contact, @phone_call]
      end
      def show
        authorize [@contact, @phone_call]
      end
    
      def update
        authorize  [@contact, @phone_call]
    
        respond_to do |format|
          if @call.update(phone_call_params)
            format.turbo_stream { render turbo_stream: turbo_stream.replace(@phone_call, partial: "profile/phone_calls/phone_call", locals: { phone_call: @phone_call }) }
          else
            format.turbo_stream { render turbo_stream: turbo_stream.replace(@phone_call, template: "profile/phone_calls/edit", locals: { phone_call: @phone_call }) }
          end
        end
      end
    
      def create
        authorize [@contact, PhoneCall]
    
        @phone_call = AddPhoneCall.call(phone_call_params, current_user, @contact).result
        respond_to do |format|
          if @phone_call.persisted?
            format.turbo_stream {
              render turbo_stream: turbo_stream.prepend(:phone_calls, partial: "profile/phone_calls/phone_call", locals: { phone_call: @phone_call }) +
                                   turbo_stream.replace(PhoneCall.new, partial: "profile/phone_calls/form", locals: { phone_call: PhoneCall.new })
            }
          else
            format.turbo_stream { render turbo_stream: turbo_stream.replace(Call.new, partial: "phone_calls/form", locals: { phone_call: @phone_call }) }
          end
        end
      end
    
      private
    
      def set_phone_call
        @phone_call= PhoneCall.find(params["id"])
      end
    
    
      def phone_call_params
        params.require(:phone_call).permit(:body)
      end
    
      end
      