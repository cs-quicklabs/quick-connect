require "swagger_helper"

RSpec.describe "api/account/fields", type: :request do
  path "/{account_id}/api/account/fields" do
    parameter name: "account_id", in: :path, type: :string, description: "account_id"
    get("list fields") do
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

    post("create field") do
      security [Bearer: {}]
      produces "application/json"
      consumes "application/json"
      parameter name: :api_field, in: :body, schema: {
        type: :'object',
        properties: { "api_field": { type: :object, properties: {
          "name": { type: :string },
          "protocol": { type: :string }, # optional
          "icon": { type: :string }, # optional
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

  path "/{account_id}/api/account/fields/{id}/edit" do
    parameter name: "account_id", in: :path, type: :string, description: "account_id"
    # You'll want to customize the parameter types...
    parameter name: "id", in: :path, type: :string, description: "id"

    get("edit field") do
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

  path "/{account_id}/api/account/fields/{id}" do
    # You'll want to customize the parameter types...
    parameter name: "account_id", in: :path, type: :string, description: "account_id"
    parameter name: "id", in: :path, type: :string, description: "id"

    patch("update field") do
      security [Bearer: {}]
      produces "application/json"
      consumes "application/json"
      parameter name: :api_field, in: :body, schema: {
        type: :'object',
        properties: { "api_field": { type: :object, properties: {
          "name": { type: :string },
          "protocol": { type: :string }, # optional
          "icon": { type: :string }, # optional
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

    delete("delete field") do
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
