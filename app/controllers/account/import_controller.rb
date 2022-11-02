class Account::ImportController < Account::BaseController
  def index
    authorize :account, :contacts?
    respond_to do |format|
      format.html
      format.csv { send_data Contact.sample, filename: "contacts-sample.csv" }
    end
  end

  def sample
    authorize :account, :contacts?
    respond_to do |format|
      format.html
      format.csv { send_data Contact.sample, filename: "contacts-sample.csv" }
    end
  end
end
