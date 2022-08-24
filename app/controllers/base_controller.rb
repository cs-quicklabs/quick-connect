class BaseController < ApplicationController
  before_action :set_user, only: %i[ index show edit update destroy create new contacts events ]
  before_action :authenticate_user!
  before_action :authenticate_account!

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::InvalidForeignKey, with: :show_referenced_alert
  rescue_from ActsAsTenant::Errors::NoTenantSet, with: :user_not_authorized
  
  include Pagy::Backend

  def authenticate_account!
    if current_user.present?
      raise Pundit::NotAuthorizedError unless current_user.account == Current.account
    end  
  end

  def show_referenced_alert(exception)
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace("modal", partial: "shared/modal", locals: { title: "Unable to Delete Record", message: "This record has been associated with other records in system therefore deleting this might result in unexpected behavior. If you want to delete this please make sure all assosications have been removed first.", main_button_visible: false })
      }
    end
  end

  def pagy_nil_safe(params, collection, vars = {})
    pagy = Pagy.new(count: collection.count(:all), page: params[:page], **vars)
    return pagy, collection.offset(pagy.offset).limit(pagy.items) if collection.respond_to?(:offset)
    return pagy, collection
  end

  LIMIT = 9
  private
  
  def set_user
    @user = current_user
  end
end
