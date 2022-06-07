require "swagger_helper"

RSpec.describe "api/passwords", type: :request do
  path "/api/password" do
    patch("update password") do
      parameter name: :user, in: :body, schema: {
        type: :'object',
        properties: { "api_user": { type: :object, properties: {
          "password": { type: :string },
          "password_confirmation": { type: :string },
          "reset_password_token": { type: :string },
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

    post("create password") do
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
