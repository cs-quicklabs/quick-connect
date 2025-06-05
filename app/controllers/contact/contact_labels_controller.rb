class Contact::ContactLabelsController < Contact::BaseController
  before_action :set_label, only: %i[create destroy]
  before_action :set_details, only: %i[create destroy]

  def create
    authorize [@contact]

    @contact.labels << @label unless @contact.labels.include?(@label)
    @contact.touched_at = Time.current
    @contact.save!
    render_response
  end

  def destroy
    authorize [@contact]
    @contact.labels.destroy(@label)
    render_response
  end

  private

  def render_response
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(
          :contact_labels,
          partial: "contact/labels",
          locals: { contact: @contact, contact_labels: @contact.labels, labels: Label.all.order(:name) },
        )
      end
    end
  end

  def set_label
    @label ||= Label.find(params[:id])
  end
end
