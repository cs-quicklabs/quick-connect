class Api::SearchController < Api::BaseController
  def contacts
    authorize [:api, :search]

    like_keyword = "%#{params[:q]}%".split(/\s+/)

    @contacts = @api_user.contacts.active.where("first_name iLIKE ANY ( array[?] )", like_keyword)
      .or(@api_user.contacts.active.where("last_name iLIKE ANY ( array[?] )", like_keyword))
      .limit(4).order(:first_name)

    render json: { success: true, data: @contacts, message: "" }
  end
end
