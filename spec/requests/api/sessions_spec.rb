require "swagger_helper"

RSpec.describe "api/sessions", type: :request do
  path "/api/login" do
    post("create session") do
      produces "application/json"
      consumes "application/json"
      parameter name: :api_user, in: :body, schema: {
        type: :'object',
        properties: { "api_user": { type: :object, properties: {
          "email": { type: :string },
          "password": { type: :string },
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

  path "/{account_id}/api/logout" do
    parameter name: "account_id", in: :path, type: :string, description: "account_id"
    delete("delete session") do
      produces "application/json"
      consumes "application/json"
      security [Bearer: {}]
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
