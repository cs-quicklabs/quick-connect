class Api::SearchController < Api::BaseController
  def contacts
    authorize [:api, :search]

    like_keyword = "%#{params[:q]}%".split(/\s+/)

    @contacts = Contact.all.available.where("first_name iLIKE ANY ( array[?] )", like_keyword)
      .or(Contact.all.available.where("last_name iLIKE ANY ( array[?] )", like_keyword))
      .limit(4).order(:first_name)

    render json: { success: true, data: @contacts, message: "" }
  end

  def relative
    authorize [:api, :search]

    like_keyword = "%#{params[:q]}%".split(/\s+/)
    @profile = params[:profile]
    @contact = [Contact.find(params[:profile])]
    @contacts = Contact.all.available.where("first_name iLIKE ANY ( array[?] )", like_keyword)
      .or(Contact.all.available.where("last_name iLIKE ANY ( array[?] )", like_keyword))
      .limit(4).order(:first_name) - @contact

    render layout: false
  end
end
