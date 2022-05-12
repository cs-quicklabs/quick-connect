class SearchController < BaseController
  def contacts
    authorize :search

    like_keyword = "%#{params[:q]}%".split(/\s+/)

    @contacts = Contact.for_current_account.where("first_name iLIKE ANY ( array[?] )", like_keyword)
    .or(Contact.for_current_account.where("last_name iLIKE ANY ( array[?] )", like_keyword))
    .limit(4).order(:first_name)
   
    render layout: false
  end
  def contact
    authorize :search

    like_keyword = "%#{params[:q]}%".split(/\s+/)
    @profile=params[:profile]
    @contacts = Contact.for_current_account.where("first_name iLIKE ANY ( array[?] )", like_keyword)
    .or(Contact.for_current_account.where("last_name iLIKE ANY ( array[?] )", like_keyword))
    .limit(4).order(:first_name)
   
    render layout: false
  end

end
