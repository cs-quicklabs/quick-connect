class Profile::RelativesController < Profile::BaseController
    before_action :set_relative, vely: %i[ show edit update destroy] 
    
      def index
        authorize [@contact, Relative]
        @relative=Relative.new
        @relatives=Relative.includes(:contact).where(first_contact_id: @contact.id) 
      end
    
      def destroy
        authorize [@contact, @relative]
    
        @relative.destroy
        Event.where(trackable: @relative).touch_all #fixes cache issues in activity
        respond_to do |format|
          format.turbo_stream { render turbo_stream: turbo_stream.remove(@relative) }
        end
      end
    
      def edit
        authorize [@contact, @relative]
      end
      def show
        authorize [@contact, @relative]
      end
    
      def update
        authorize  [@contact, @relative]
    
        respond_to do |format|
          if @relative.update(relative_params)
            format.turbo_stream { render turbo_stream: turbo_stream.replace(@relative, partial: "profile/relatives/relative", locals: { relative: @relative }) }
          else
            format.turbo_stream { render turbo_stream: turbo_stream.replace(@relative, template: "profile/relatives/edit", locals: { relative: @relative }) }
          end
        end
      end
    
      def create
        authorize [@contact, Relative]
        @relative = AddRelative.call(relative_params, current_user, @contact).result
        binding.irb
        respond_to do |format|
          if @relative.persisted?
            format.turbo_stream {
              render turbo_stream: turbo_stream.prepend(:relatives, partial: "profile/relatives/relative", locals: { relative: @relative }) +
                                   turbo_stream.replace(Relative.new, partial: "profile/relatives/form", locals: { relative: Relative.new })
            }
          else
            format.turbo_stream { render turbo_stream: turbo_stream.replace(relative.new, partial: "profile/relatives/form", locals: { relative: @relative }) }
          end
        end
      end

      def form
        authorize @contact, Relative
        @relative=Contact.find(params[:id])
      end
    
      private
    
      def set_relative
        @relative= Relative.where(first_contact_id: params[:id]) 
      end
    
    
      def relative_params
        params.require(:relative).permit(:first_contact_id,:relation_id, :contact_id)
      end
    
      end
      