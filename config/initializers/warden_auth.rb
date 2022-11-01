# config/initializers/warden_auth.rb
Warden::JWTAuth.configure do |config|
  config.secret = Rails.application.secrets.secret_key_base
  config.dispatch_requests = [
    ["POST", %r{^/api/login$}],
    ["POST", %r{^/api/login.json$}],
  ]
  config.revocation_requests = [
    ["DELETE", %r{^/api/logout$}],
    ["DELETE", %r{^/api/logout.json$}],
  ]
end
