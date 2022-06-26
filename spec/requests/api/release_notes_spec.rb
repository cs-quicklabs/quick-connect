require "swagger_helper"

RSpec.describe "api/release_notes", type: :request do
  path "/{account_id}/api/release_notes?page={page}" do
    parameter name: "account_id", in: :path, type: :string, description: "account_id"
    parameter name: "page", in: :path, type: :integer, description: "page"
    get("list release_notes") do
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
  path "/{account_id}/api/release_notes/{id}" do
    parameter name: "account_id", in: :path, type: :string, description: "account_id"
    parameter name: "id", in: :path, type: :string, description: "release_note_id"

    get("show release_notes") do
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
