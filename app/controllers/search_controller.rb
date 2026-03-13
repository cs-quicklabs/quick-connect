class SearchController < BaseController
  def contacts
    authorize :search
    keywords = search_keywords(params[:q])

    @contacts = search_contacts_by_name(Contact.available, keywords)
      .order(:first_name).limit(5).uniq

    render layout: false
  end

  def nav
    authorize :search
    keywords = search_keywords(params[:q])

    @contacts = search_contacts_by_name(Contact.available, keywords)
      .order(:first_name).limit(3).uniq
    @batches = Batch.all.where(*like_any("name", keywords)).order(:name).limit(3)
    render layout: false
  end

  def contact
    authorize :search
    keywords = search_keywords(params[:q])
    @profile = params[:profile]

    @contact = [Contact.find(params[:profile])] + Contact.joins(:relatives).where("relatives.first_contact_id=? OR relatives.contact_id=?", @profile, @profile)
    @contacts = search_contacts_by_name(Contact.available, keywords)
      .order(:first_name).limit(5).uniq - @contact

    render layout: false
  end

  def add
    authorize :search
    keywords = search_keywords(params[:q])
    @batch = Batch.find(params[:batch_id])
    @added = @batch.contacts

    @contacts = search_contacts_by_name(Contact.available, keywords)
      .order(:first_name).limit(5).uniq - @added

    render layout: false
  end

  def collection
    authorize :search
    keywords = search_keywords(params[:q])
    @collection = Collection.find(params[:collection_id])
    @added = @collection.batches

    @batches = Batch.where(*like_any("name", keywords)).order(:name).limit(5).uniq - @added

    render layout: false
  end

  private

  def search_keywords(query)
    "%#{query}%".split(/\s+/)
  end

  def like_any(column, keywords)
    conditions = keywords.map { "#{column} LIKE ?" }.join(" OR ")
    [conditions, *keywords]
  end

  def search_contacts_by_name(scope, keywords)
    first_cond = like_any("first_name", keywords)
    last_cond = like_any("last_name", keywords)
    both_sql = "(#{first_cond[0]}) AND (#{last_cond[0]})"

    scope.where(*first_cond)
      .or(scope.where(*last_cond))
      .or(scope.where(both_sql, *first_cond[1..], *last_cond[1..]))
  end
end
