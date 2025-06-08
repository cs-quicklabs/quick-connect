class AccountMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request = ActionDispatch::Request.new env
    #_, account_id, request_path = env["REQUEST_PATH"].split("/", 3)
    account_id = 16

    account = Account.find_by(id: account_id)
    Current.account = account
    ActsAsTenant.current_tenant = account
    if account.expired? and request_path != "expired" and not env["REQUEST_PATH"].include?("sign_out")
      return [302, { "Location" => "/#{account.id}/expired" }, []]
    end

    env["SCRIPT_NAME"] = "/#{account_id}"

    @app.call(env)
  end
end
