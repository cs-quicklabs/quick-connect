class Profile::BaseController < BaseController
  before_action :set_contact, only: %i[index show edit update create destroy new]
  after_action :verify_authorized
  before_action :set_labels, only: %i[index]
  before_action :set_relations, only: %i[index]
  include Pagy::Backend

  private

  def set_contact
    @contact ||= Contact.find_by_id(params[:profile_id]) 
  end
  def set_labels
    @labels ||= Label.all.order(:name)
  end
  def set_relations
    @relations ||= Relation.all.order(:name)
  end
end
