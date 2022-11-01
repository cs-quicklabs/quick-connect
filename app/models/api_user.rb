# app/models/api_user.rb
class ApiUser < User
  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :jwt_authenticatable, jwt_revocation_strategy: self
  validates :jti, presence: true

  def generate_jwt
    JWT.encode({ id: id,
                 exp: 5.days.from_now.to_i },
               Rails.application.secrets.secret_key_base)
  end
end
