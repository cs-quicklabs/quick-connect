require "swagger_helper"

RSpec.describe "api/journals", type: :request do
  path "/{account_id}/api/journals?page={page}" do
    parameter name: "account_id", in: :path, type: :string, description: "account_id"
    parameter name: "page", in: :path, type: :integer, description: "page"
    get("list journals") do
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
  path "/{account_id}/api/journals" do
    parameter name: "account_id", in: :path, type: :string, description: "account_id"

    post("create journal") do
      security [Bearer: {}]
      produces "application/json"
      consumes "application/json"
      parameter name: :api_journal, in: :body, schema: {
        type: :'object',
        properties: { "api_journal": { type: :object, properties: {
          "title": { type: :string },
          "body": { type: :string },
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

  path "/{account_id}/api/journals/{id}/edit" do
    parameter name: "account_id", in: :path, type: :string, description: "account_id"
    # You'll want to customize the parameter types...
    parameter name: "id", in: :path, type: :string, description: "id"

    get("edit journal") do
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

  path "/{account_id}/api/journals/{id}" do
    # You'll want to customize the parameter types...
    parameter name: "account_id", in: :path, type: :string, description: "account_id"
    parameter name: "id", in: :path, type: :string, description: "id"

    get("show journal") do
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

    patch("update journal") do
      security [Bearer: {}]
      produces "application/json"
      consumes "application/json"
      parameter name: :api_journal, in: :body, schema: {
        type: :'object',
        properties: { "api_journal": { type: :object, properties: {
          "title": { type: :string },
          "body": { type: :string },
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

    delete("delete journal") do
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
