class Api::Contact::AboutController < Api::Contact::BaseController
  include Pagy::Backend

  def index
    authorize [:api, @contact, :about]
    render json: { suceess: true, data: @contact.about, message: "About Contact" }
  end
end
