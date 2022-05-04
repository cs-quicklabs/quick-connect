class ContactsController < BaseController
    include Pagy::Backend
  
    before_action :set_contact, only: %i[ show edit update destroy]
  
    def index
      authorize :contact
  
      @contacts = Contact.for_current_account.order(:first_name)
      if !@contacts.empty? 
        @contact= Contact.for_current_account.first
      end
    end
  
    def new
      authorize :contact
  
      @contact = Contact.new
    end
  
    def edit
      authorize :contact
    end
  
    def update
      authorize :contact
  
      respond_to do |format|
        if @contact.update(contact_params)
          format.html { redirect_to contact_path(@contact), notice: "Contact was successfully updated." }
        else
          format.turbo_stream { render turbo_stream: turbo_stream.replace(@contact, partial: "contacts/form", locals: { contact: @contact, title: "Edit Contact"  }) }
        end
      end
    end
  
    def create
      authorize :contact
  
      @contact = CreateContact.call(contact_params, @user).result
      respond_to do |format|
        
        if @contact.errors.empty?
          format.html { redirect_to contact_path(@contact), notice: "Contact was successfully created." }
        else
          format.turbo_stream { render turbo_stream: turbo_stream.replace(Contact.new, partial: "contacts/form", locals: { contact: @contact, title: "Add New Contact" }) }
        end
      end
    end
  
    def show
      authorize @contact
       @contacts = Contact.for_current_account.order(:first_name) 
    end
  
    def destroy
      authorize :contact
  
      respond_to do |format|
        if @contact.destroy
          format.turbo_stream { redirect_to contacts_path, status: 303, notice: "Contact was removed successfully." }
        else
          format.turbo_stream { redirect_to contacts_path, status: 303, alert: "Failed to remove contact." }
        end
      end
    end
  
    private
  
    def set_contact
      @contact ||= Contact.find(params[:id]) 
    end
  
    def contact_params
      params.require(:contact).permit(:first_name, :last_name, :email, :phone,  :birthday,:address, :about)
    end
  end
  