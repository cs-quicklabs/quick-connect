class Api::Contact::RelationsController < Api::Contact::BaseController
  before_action :set_relation, only: %i[update destroy]

  def update
    authorize [@contact, @relation]
    @contact.update(relation_id: @relation.id)
    render json: { success: true, data: @contact, message: "Relation added successfully" }
  end

  def destroy
    authorize [@contact, @relation]
    @contact.update(relation_id: nil)
    render json: { success: true, data: @contact, message: "Relation removed successfully" }
  end

  private

  def set_relation
    @relation = Relation.find(params["id"])
  end
end
