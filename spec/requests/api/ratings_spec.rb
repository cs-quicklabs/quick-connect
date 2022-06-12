require "swagger_helper"

RSpec.describe "api/ratings", type: :request do
  path "/{account_id}/api/ratings" do
    parameter name: "account_id", in: :path, type: :string, description: "account_id"
    get("list ratings") do
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

    post("create rating") do
      security [Bearer: {}]
      produces "application/json"
      consumes "application/json"
      parameter name: :api_rating, in: :body, schema: {
        type: :'object',
        properties: { "api_rating": { type: :object, properties: {
          "rating": { type: :integer },
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
