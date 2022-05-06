class ProfileController < BaseController
  include Pagy::Backend

  before_action :set_contact, only: %i[ show ]

  before_action :set_labels, only: %i[show]
  before_action :set_relations, only: %i[show]

  def show
    authorize @contact
  
  end


  private

  def set_contact
    @contact ||= Contact.find(params[:id])
  end
  def set_labels
    @labels ||= Label.all.order(:name)
  end
  def set_relations
    @relations ||= Relation.all.order(:name)
  end
end
