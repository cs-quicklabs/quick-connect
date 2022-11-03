class SearchController < BaseController
  def contacts
    authorize :search

    like_keyword = "%#{params[:q]}%".split(/\s+/)

    @contacts = Contact.all.available.where("first_name iLIKE ANY ( array[?] )", like_keyword)
      .or(Contact.all.available.where("last_name iLIKE ANY ( array[?] )", like_keyword))
      .or(Contact.all.available.where("first_name iLIKE ANY ( array[?] ) and last_name iLIKE ANY ( array[?] )", like_keyword, like_keyword))
      .order(:first_name).limit(5).uniq

    render layout: false
  end

  def nav
    authorize :search
if 
    like_keyword = "%#{params[:q]}%".split(/\s+/)

    @results = Contact.all.available.where("first_name iLIKE ANY ( array[?] )", like_keyword)
      .or(Contact.all.available.where("last_name iLIKE ANY ( array[?] )", like_keyword))
      .or(Contact.all.available.where("first_name iLIKE ANY ( array[?] ) and last_name iLIKE ANY ( array[?] )", like_keyword, like_keyword))
      .order(:first_name).limit(3).uniq + Batch.all.where("name iLIKE ANY ( array[?] )", like_keyword).order(:name).limit(2)

    render layout: false
  end

  def contact
    authorize :search

    like_keyword = "%#{params[:q]}%".split(/\s+/)
    @profile = params[:profile]

    @contact = [Contact.find(params[:profile])] + Contact.joins(:relatives).where("relatives.first_contact_id=? OR relatives.contact_id=?", @profile, @profile)
    @contacts = Contact.all.available.where("first_name iLIKE ANY ( array[?] )", like_keyword)
      .or(Contact.all.available.where("last_name iLIKE ANY ( array[?] )", like_keyword))
      .or(Contact.all.available.where("first_name iLIKE ANY ( array[?] ) and last_name iLIKE ANY ( array[?] )", like_keyword, like_keyword))
      .order(:first_name).uniq.limit(5) - @contact

    render layout: false
  end

  def add
    authorize :search

    like_keyword = "%#{params[:q]}%".split(/\s+/)
    @batch = Batch.find(params[:batch_id])
    @added = @batch.contacts

    @contacts = Contact.all.available.where("first_name iLIKE ANY ( array[?] )", like_keyword)
      .or(Contact.all.available.where("last_name iLIKE ANY ( array[?] )", like_keyword))
      .or(Contact.all.available.where("first_name iLIKE ANY ( array[?] ) and last_name iLIKE ANY ( array[?] )", like_keyword, like_keyword))
      .order(:first_name).uniq.limit(5) - @added

    render layout: false
  end
end
