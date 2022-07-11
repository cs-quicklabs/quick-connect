require "swagger_helper"

RSpec.describe "api/search", type: :request do
  path "/{account_id}/api/search/contacts" do
    parameter name: "account_id", in: :path, type: :string, description: "account_id"
    parameter name: "q", in: :path, type: :string, description: "search keyword"
    get("contacts search") do
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
  path "/{account_id}/api/search/relative?q={q}&profile={profile}" do
    parameter name: "account_id", in: :path, type: :string, description: "account_id"
    parameter name: "q", in: :path, type: :string, description: "search keyword"
    parameter name: "profile", in: :path, type: :string, description: "contact for which relative is to be added"
    get("contacts search") do
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
