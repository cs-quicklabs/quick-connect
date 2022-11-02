class SearchController < BaseController
  def contacts
    authorize :search

    like_keyword = "%#{params[:q]}%".split(/\s+/)

    @contacts = Contact.all.available.where("first_name iLIKE ANY ( array[?] )", like_keyword)
      .or(Contact.all.available.where("last_name iLIKE ANY ( array[?] )", like_keyword))
      .limit(4).order(:first_name)

    render layout: false
  end

  def nav
    authorize :search

    like_keyword = "%#{params[:q]}%".split(/\s+/)

    @results = Contact.all.available.where("first_name iLIKE ANY ( array[?] )", like_keyword)
      .or(Contact.all.available.where("last_name iLIKE ANY ( array[?] )", like_keyword))
      .limit(4).order(:first_name) + Batch.all.where("name iLIKE ANY ( array[?] )", like_keyword)

    render layout: false
  end

  def contact
    authorize :search

    like_keyword = "%#{params[:q]}%".split(/\s+/)
    @profile = params[:profile]

    @contact = [Contact.find(params[:profile])] + Contact.joins(:relatives).where("relatives.first_contact_id=? OR relatives.contact_id=?", @profile, @profile)
    @contacts = Contact.all.available.where("first_name iLIKE ANY ( array[?] )", like_keyword)
      .or(Contact.all.available.where("last_name iLIKE ANY ( array[?] )", like_keyword))
      .limit(4).order(:first_name) - @contact

    render layout: false
  end

  def add
    authorize :search

    like_keyword = "%#{params[:q]}%".split(/\s+/)
    @batch = Batch.find(params[:batch_id])
    @added = @batch.contacts

    @contacts = Contact.all.available.where("first_name iLIKE ANY ( array[?] )", like_keyword)
      .or(Contact.all.available.where("last_name iLIKE ANY ( array[?] )", like_keyword))
      .limit(4).order(:first_name) - @added

    render layout: false
  end
end
