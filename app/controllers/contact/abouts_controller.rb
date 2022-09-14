class Contact::AboutsController < Contact::BaseController
  include ActionView::RecordIdentifier
  before_action :set_about, only: %i[show edit update destroy]

  def index
    authorize [@contact, About]
  end

  def edit
    authorize [@contact, @about]
  end

  def update
    authorize [@contact, @about]
    respond_to do |format|
      if @about.update(about_params)
        @contact.events.create(user: current_user, action: "about", action_for_context: "added about", trackable: @about, action_context: "added about")
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@about, partial: "contact/abouts/about", locals: { about: @about, contact: @contact }) }
      end
    end
  end

  def destroy
    authorize [@contact, @about]
    @about.assign_attributes({ "#{params[:delete]}" => nil })
    @about.save!
    respond_to do |format|
      @contact.events.create(user: current_user, action: "deleted", action_for_context: "deleted about", trackable: about, action_context: "deleted about")
      format.turbo_stream { render turbo_stream: turbo_stream.replace(@about, partial: "contact/abouts/about", locals: { about: @about, contact: @contact }) }
    end
  end

  private

  def about_params
    params.require(:about).permit(:address, :breif, :met, :habit, :work, :other)
  end

  def set_about
    @about = @contact.abouts
  end
end
