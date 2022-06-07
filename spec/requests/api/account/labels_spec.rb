require "swagger_helper"

RSpec.describe "api/account/labels", type: :request do
  path "/{account_id}/api/account/labels" do
    parameter name: "account_id", in: :path, type: :string, description: "account_id"

    get("list labels") do
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

    post("create label") do
      security [Bearer: {}]
      produces "application/json"
      consumes "application/json"
      parameter name: :api_label, in: :body, schema: {
        type: :'object',
        properties: { "api_label": { type: :object, properties: {
          "name": { type: :string },
          "color": { type: :string },
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

  path "/{account_id}/api/account/labels/{id}/edit" do
    parameter name: "account_id", in: :path, type: :string, description: "account_id"

    # You'll want to customize the parameter types...
    parameter name: "id", in: :path, type: :string, description: "id"

    get("edit label") do
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

  path "/{account_id}/api/account/labels/{id}" do
    parameter name: "account_id", in: :path, type: :string, description: "account_id"

    # You'll want to customize the parameter types...
    parameter name: "id", in: :path, type: :string, description: "id"

    patch("update label") do
      security [Bearer: {}]
      produces "application/json"
      consumes "application/json"
      parameter name: :api_label, in: :body, schema: {
                  type: :'object',
                  properties: { "api_label": { type: :object, properties: {
                    "name": { type: :string },
                    "color": { type: :string },
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

    delete("delete label") do
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
