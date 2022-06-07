require "swagger_helper"

RSpec.describe "api/confirmations", type: :request do
  path "/api/confirmation" do
    get("show confirmation") do
      produces "application/json"
      consumes "application/json"
      parameter name: :confirmation_token, in: :query, type: :string
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

    post("create confirmation") do
      produces "application/json"
      consumes "application/json"
      parameter name: :user, in: :body, schema: {
        type: :'object',
        properties: { "api_user": { type: :object, properties: {
          "email": { type: :string },
        } } },
      }
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
