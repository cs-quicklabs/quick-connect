class Contact::ContactLabelsController < Contact::BaseController
  before_action :set_label, only: %i[create destroy]
  before_action :set_details, only: %i[create destroy]

  def create
    authorize [@contact]

    @contact.labels << @label unless @contact.labels.include?(@label)
    @contact.touched_at = Time.current
    @contact.save!
    respond_to do |format|
      format.html do
        redirect_to request.referer, notice: "Label added successfully."
      end
    end
  end

  def destroy
    authorize [@contact]
    @contact.labels.destroy(@label)
  end

  private

  def set_label
    @label ||= Label.find(params[:id])
  end
end
