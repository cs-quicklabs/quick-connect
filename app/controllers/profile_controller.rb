class ProfileController < BaseController
  include Pagy::Backend

  before_action :set_contact, only: %i[ show ]



  def show
    authorize @contact
  end


  private

  def set_contact
    @contact ||= Contact.find(params[:id])
  end
end
