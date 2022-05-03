class SignUpForm
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :first_name, :last_name, :email,  :password, :password_confirmation, :account, :user

  validates_presence_of :first_name, :last_name, :email,  :password, :password_confirmation
  validates :password, not_pwned: true
  validates_length_of :password, minimum: 6
  validate :validate_children

  def initialize(*)
    super
  end

  def submit(registration_params)
    build_children(registration_params)

    result = nil
    if valid?
      result = SignUp.call(user).result
    end
    result
  end

  def build_children(registration_params)
    self.first_name = registration_params[:first_name]
    self.last_name = registration_params[:last_name]
    self.email = registration_params[:email]
    self.password = registration_params[:password]
    self.password_confirmation = registration_params[:password_confirmation]

    @user = User.new(first_name: first_name,
                     last_name: last_name,
                     email: email,
                     password: password,
                     password_confirmation: password_confirmation)
  end

  def validate_children
    promote_errors(user) if user.invalid?
  end

  def promote_errors(child)
    child.errors.each do |error|
      errors.errors.append(error) if error.attribute == :email and email_error_non_exisisting?
    end
  end

  def email_error_non_exisisting?
    errors.errors.each do |error|
      return false if error.attribute == :email
    end
    true
  end

  def persisted?
    false
  end
end
