class Contact::AboutController < Contact::BaseController
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
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@about, partial: "contact/abouts/about", locals: { about: @about, contact: @contact }) }
      end
    end
  end

  def destroy
    authorize [@contact, @about]
    @about.assign_attributes({ "#{params[:delete]}" => nil })
    @about.save!
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace(@about, partial: "contact/abouts/about", locals: { about: @about, contact: @contact }) }
    end
  end

  private

  def about_params
    params.require(:about).permit(:address, :breif, :met, :habit, :work, :other)
  end

  def set_about
    if @about
      return @about
    end
    @about = @contact.abouts
  end
end
