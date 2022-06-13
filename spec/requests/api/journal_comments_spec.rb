require "swagger_helper"

RSpec.describe "api/journal_comments", type: :request do
  path "/{account_id}/api/journal_comments" do
    parameter name: "account_id", in: :path, type: :string, description: "account_id"
    post("create journal_comment") do
      security [Bearer: {}]
      produces "application/json"
      consumes "application/json"
      parameter name: :api_comment, in: :body, schema: {
                  type: :'object',
                  properties: { "api_comment": { type: :object, properties: {
                    "title": { type: :string },
                    "journal_id": { type: :integer },
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

  path "/{account_id}/api/journal_comments/{id}/edit" do
    parameter name: "account_id", in: :path, type: :string, description: "account_id"
    # You'll want to customize the parameter types...
    parameter name: "id", in: :path, type: :string, description: "id"

    get("edit journal_comment") do
      security [Bearer: {}]
      produces "application/json"
      consumes "application/json"
      response(200, "successful") do
        let(:id) { "123" }

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

  path "/{account_id}/api/journal_comments/{id}" do
    parameter name: "account_id", in: :path, type: :string, description: "account_id"
    parameter name: "id", in: :path, type: :string, description: "id"
    patch("update journal_comment") do
      security [Bearer: {}]
      produces "application/json"
      consumes "application/json"
      parameter name: :api_comment, in: :body, schema: {
                  type: :'object',
                  properties: { "api_comment": { type: :object, properties: {
                    "title": { type: :string },
                    "journal_id": { type: :integer },
                  } } },
                }
      response(200, "successful") do
        let(:id) { "123" }

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
    delete("delete journal_comment") do
      security [Bearer: {}]
      produces "application/json"
      consumes "application/json"
      response(200, "successful") do
        let(:id) { "123" }

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
