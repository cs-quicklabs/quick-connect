# app/models/api_user.rb
class ApiUser < User
  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :jwt_authenticatable, jwt_revocation_strategy: self
  validates :jti, presence: true

  def generate_jwt
    JWT.encode({ id: id,
                 exp: 2.days.from_now.to_i },
               Rails.application.credentials.secret_key_base, true, { :algorithm => "HS256" })
  end
end
