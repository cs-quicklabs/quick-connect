class Account::ImportController < Account::BaseController
  def index
    authorize :account, :contacts?
  end
end
