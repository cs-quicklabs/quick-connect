require "swagger_helper"

RSpec.describe "api/account/relations", type: :request do
  path "/{account_id}/api/account/relations" do
    parameter name: "account_id", in: :path, type: :string, description: "account_id"
    get("list relations") do
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

    post("create relation") do
      security [Bearer: {}]
      produces "application/json"
      consumes "application/json"
      parameter name: :api_relation, in: :body, schema: {
        type: :'object',
        properties: { "api_relation": { type: :object, properties: {
          "name": { type: :string },
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

  path "/{account_id}/api/account/relations/{id}/edit" do
    parameter name: "account_id", in: :path, type: :string, description: "account_id"
    # You'll want to customize the parameter types...
    parameter name: "id", in: :path, type: :string, description: "id"

    get("edit relation") do
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

  path "/{account_id}/api/account/relations/{id}" do
    parameter name: "account_id", in: :path, type: :string, description: "account_id"
    # You'll want to customize the parameter types...
    parameter name: "id", in: :path, type: :string, description: "id"

    patch("update relation") do
      security [Bearer: {}]
      produces "application/json"
      consumes "application/json"
      parameter name: :api_relation, in: :body, schema: {
        type: :'object',
        properties: { "api_relation": { type: :object, properties: {
          "name": { type: :string },
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

    delete("delete relation") do
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
