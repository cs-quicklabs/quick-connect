require "swagger_helper"

RSpec.describe "api/dashboard", type: :request do
  path "/{account_id}/api/dashboard" do
    parameter name: "account_id", in: :path, type: :string, description: "account_id"
    get("list dashboards") do
      security [Bearer: {}]
      produces "application/json"
      consumes "application/json"
      response(200, "successful") do
        after do |example|
          example.metadata[:response][:content] = {
            "application/json" => {
              example: JSON.parse(response.body, symbolize_names: true),
            },
          }
        end
        run_test!
      end
    end
  end
end
