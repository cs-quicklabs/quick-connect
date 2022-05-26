class Api::Contact::AboutController < Api::Contact::BaseController
  include Pagy::Backend

  def index
    authorize [@contact, About]
    render json: { success: true, data: { contact: @contact }, message: "About was successfully retrieved." }
  end
end
