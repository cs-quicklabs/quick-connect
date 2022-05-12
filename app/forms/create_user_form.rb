class CreateUserForm
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :first_name, :last_name, :email, :actor, :account

  validates_presence_of :first_name, :last_name, :email

  def initialize(account, actor)
    @account = account
    @actor = actor
  end

  def submit(params, invite)
    self.first_name = params[:first_name]
    self.last_name = params[:last_name]
    self.email = params[:email]

    if valid?
      CreateUser.call(params, actor, account, invite).result
    else
      false
    end
  end

  def persisted?
    false
  end
end
