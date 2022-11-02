class Api::SearchController < Api::BaseController
  def contacts
    authorize [:api, :search]

    like_keyword = "#{params[:q]}".split(/\s+/)
    contacts = Contact.all.available.where("first_name iLIKE ANY ( array[?] )", like_keyword)
      .or(Contact.all.available.where("last_name iLIKE ANY ( array[?] )", like_keyword))
      .or(Contact.all.available.where("first_name iLIKE ANY ( array[?] ) and last_name iLIKE ANY ( array[?] )", like_keyword, like_keyword))
      .order(:first_name).uniq
    @pagy, @contacts = pagy_array_safe(params, contacts, items: LIMIT)

    render json: { pagy: pagination_meta(pagy_metadata(@pagy)), success: true, data: @contacts, message: "" }
  end

  def relative
    authorize [:api, :search]

    like_keyword = "%#{params[:q]}%".split(/\s+/)
    @profile = params[:profile]
    @contact = [Contact.find(params[:profile])]
    contacts = Contact.all.available.where("first_name iLIKE ANY ( array[?] )", like_keyword)
      .or(Contact.all.available.where("last_name iLIKE ANY ( array[?] )", like_keyword))
      .or(Contact.all.available.where("first_name iLIKE ANY ( array[?] ) and last_name iLIKE ANY ( array[?] )", like_keyword, like_keyword))
      .order(:first_name).uniq - @contact
    @pagy, @contacts = pagy_array_safe(params, contacts, items: LIMIT)
    render json: { pagy: pagination_meta(pagy_metadata(@pagy)), success: true, data: @contacts, message: "" }
  end

  def add
    authorize [:api, :search]

    like_keyword = "%#{params[:q]}%".split(/\s+/)
    @batch = Batch.find(params[:batch_id])
    @added = @batch.contacts

    contacts = Contact.all.available.where("first_name iLIKE ANY ( array[?] )", like_keyword)
      .or(Contact.all.available.where("last_name iLIKE ANY ( array[?] )", like_keyword))
      .or(Contact.all.available.where("first_name iLIKE ANY ( array[?] ) and last_name iLIKE ANY ( array[?] )", like_keyword, like_keyword))
      .order(:first_name).uniq - @added
    @pagy, @contacts = pagy_array_safe(params, contacts, items: LIMIT)
    render json: { pagy: pagination_meta(pagy_metadata(@pagy)), success: true, data: @contacts, message: "" }
  end
end
