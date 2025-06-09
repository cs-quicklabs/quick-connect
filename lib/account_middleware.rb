class AccountMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request = ActionDispatch::Request.new(env)
    path_segments = env["REQUEST_PATH"].to_s.split("/", 3)
    _, account_id, request_path = path_segments

    if account_id&.match?(/^\d+$/)
      account = Account.find(account_id)
      if account
        # Set the current account for ActsAsTenant and Current
        Current.account = account
        ActsAsTenant.current_tenant = account

        if account.expired? && request_path != "expired" && !env["REQUEST_PATH"].include?("sign_out")
          return redirect_to("/#{account.id}/expired")
        end
      else
        return redirect_to("/")
      end

      update_env_for_account(env, account_id, request_path)
    end

    @app.call(env)
  end

  private

  def redirect_to(location)
    [302, { "Location" => location, "Content-Type" => "text/html" }, []]
  end

  def update_env_for_account(env, account_id, request_path)
    env["SCRIPT_NAME"] = "/#{account_id}"
    env["PATH_INFO"] = "/#{request_path}"
    env["REQUEST_PATH"] = "/#{request_path}"
    env["REQUEST_URI"] = "/#{request_path}"
  end
end
