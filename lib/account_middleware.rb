class AccountMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request = ActionDispatch::Request.new env
    _, account_id, request_path = env["REQUEST_PATH"].split("/", 3)

    if account_id =~ /\d+/
      if account = Account.find_by(id: account_id)
        Current.account = account
        ActsAsTenant.current_tenant = account
        if account.expired? and request_path != "expired" and not env["REQUEST_PATH"].include?("sign_out")
          return [302, { "Location" => "/#{account.id}/expired" }, []]
        end
      else
        return [302, { "Location" => "/" }, []]
      end

      env["SCRIPT_NAME"] = "/#{account_id}"
      env["PATH_INFO"] = "/#{request_path}"
      env["REQUEST_PATH"] = "/#{request_path}"
      env["REQUEST_URI"] = "/#{request_path}"
    end

    @app.call(env)
  end
end
