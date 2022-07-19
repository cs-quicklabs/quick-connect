require "swagger_helper"

RSpec.describe "api/account/life_events", type: :request do
  path "/{account_id}/api/account/life_events" do
    parameter name: "account_id", in: :path, type: :string, description: "account_id"

    get("list life_events") do
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

    post("create activity") do
      security [Bearer: {}]
      produces "application/json"
      consumes "application/json"
      parameter name: :api_life_event, in: :body, schema: {
        type: :'object',
        properties: { "api_life_event": { type: :object, properties: {
          "name": { type: :string },
          "group_id": { type: :integer },
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
  path "/{account_id}/api/account/life_event/new" do
    # You'll want to customize the parameter types...
    parameter name: "account_id", in: :path, type: :string, description: "account_id"
    get("fetch groups (categories)") do
      security [Bearer: {}]
      produces "application/json"
      consumes "application/json"
      response(200, "successful") do
        let(:contact_id) { "123" }

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

  path "/{account_id}/api/account/life_events/{id}/edit" do
    parameter name: "account_id", in: :path, type: :string, description: "account_id"

    # You'll want to customize the parameter types...
    parameter name: "id", in: :path, type: :string, description: "id"

    get("edit activity") do
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

  path "/{account_id}/api/account/life_events/{id}" do
    parameter name: "account_id", in: :path, type: :string, description: "account_id"

    # You'll want to customize the parameter types...
    parameter name: "id", in: :path, type: :string, description: "id"

    patch("update activity") do
      security [Bearer: {}]
      produces "application/json"
      consumes "application/json"
      parameter name: :api_life_event, in: :body, schema: {
                  type: :'object',
                  properties: { "api_life_event": { type: :object, properties: {
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

    delete("delete activity") do
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
