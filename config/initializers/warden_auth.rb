# config/initializers/warden_auth.rb
Warden::JWTAuth.configure do |config|
  config.secret = "aOiynmWWvo17LrD9XTENHp9czMpuw4kH"
  config.dispatch_requests = [
    ["POST", %r{^/api/login$}],
    ["POST", %r{^/api/login.json$}],
  ]
  config.revocation_requests = [
    ["DELETE", %r{^/api/logout$}],
    ["DELETE", %r{^/api/logout.json$}],
  ]
end
