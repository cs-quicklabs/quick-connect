class Api::Contact::AboutsController < Api::Contact::BaseController
  include ActionView::RecordIdentifier
  before_action :set_about, only: %i[show edit update destroy]

  def index
    authorize [:api, @contact, About]
    render json: { success: true, data: @contact.abouts, message: "About fetched successfully" }
  end

  def edit
    authorize [:api, @contact, @about]
    render json: { success: true, data: @contact.abouts, message: "About fetched successfully" }
  end

  def update
    authorize [:api, @contact, @about]
    if @about.update(about_params)
      @contact.events.create(user: @api_user, action: "about", action_for_context: "added about", trackable: @about, action_context: "added about")
      render json: { success: true, data: @contact.abouts, message: "About updated successfully" }
    end
  end

  def destroy
    authorize [:api, @contact, @about]
    @about.assign_attributes({ "#{params[:delete]}" => nil })
    @about.save!
    @contact.events.create(user: @api_user, action: "deleted", action_for_context: "deleted about", trackable: @about, action_context: "deleted about")
    render json: { success: true, data: @contact.abouts, message: "About updated successfully" }
  end

  private

  def about_params
    params.require(:api_about).permit(:address, :breif, :met, :habit, :work, :other)
  end

  def set_about
    @about = @contact.abouts
  end
end
