class Account::ExportController < Account::BaseController
  def index
    authorize :account, :contacts?
    respond_to do |format|
      format.html
      format.csv { send_data Contact.all.available.order(:first_name).to_csv, filename: "contacts-#{Date.today}.csv" }
    end
  end
end
