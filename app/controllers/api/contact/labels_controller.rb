class Api::Contact::LabelsController < Api::Contact::BaseController
  before_action :set_label, only: %i[update destroy]

  def update
    authorize [@contact, @label]
    @contact.labels << @label
    render json: { success: true, data: @contact, message: "Label added successfully" }
  end

  def destroy
    authorize [@contact, @label]
    @contact.labels.destroy @label
    render json: { success: true, data: @contact, message: "label removed successfully" }
  end

  private

  def set_label
    @label = Label.find(params["id"])
  end
end
