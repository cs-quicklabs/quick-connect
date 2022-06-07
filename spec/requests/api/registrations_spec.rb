require "swagger_helper"

RSpec.describe "api/registrations", type: :request do
  path "/api/users" do
    post("create registration") do
      produces "application/json"
      consumes "application/json"
      parameter name: :api_user, in: :body, schema: {
        type: :'object',
        properties: { "api_user": { type: :object, properties: {
          "first_name": { type: :string },
          "last_name": { type: :string },
          "password": { type: :string },
          "password_confirmation": { type: :string },
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
