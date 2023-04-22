class Report::ContactsController < Report::BaseController
  def index
    authorize :report
    @add_contacts_report = Contact.all.group("DATE_TRUNC('month', created_at)").count.values.map(&:to_i)
    binding.irb
  end

  def weekly
    authorize :report
    @add_contacts_report = Contact.all.group("DATE_TRUNC('week', created_at)").count.values.map(&:to_i)
  end

  def monthly
    authorize :report
    @add_contacts_report = Contact.all.group("DATE_TRUNC('month', created_at)").count.values.map(&:to_i)
  end

  def yearly
    authorize :report
    @add_contacts_report = Contact.all.group("DATE_TRUNC('year', created_at)").count.values.map(&:to_i)
  end

  def all
    authorize :report
    @start_year = Contact.all.order(:created_at).first.created_at.year
    @add_contacts_report = Contact.all.group("DATE_TRUNC('year', created_at)").count.values.map(&:to_i)
  end
end
