require "swagger_helper"

RSpec.describe "api/contact/contact_activities", type: :request do
  path "/{account_id}/api/contacts/{contact_id}/contact_activities?page={page}" do
    # You'll want to customize the parameter types...
    parameter name: "account_id", in: :path, type: :string, description: "account_id"
    parameter name: "contact_id", in: :path, type: :string, description: "contact_id"
    parameter name: "page", in: :path, type: :integer, description: "page"

    get("list contact activities") do
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
  path "/{account_id}/api/contacts/{contact_id}/contact_activities" do
    # You'll want to customize the parameter types...
    parameter name: "account_id", in: :path, type: :string, description: "account_id"
    parameter name: "contact_id", in: :path, type: :string, description: "contact_id"

    post("create contact activity") do
      security [Bearer: {}]
      produces "application/json"
      consumes "application/json"
      parameter name: :api_contact_activity, in: :body, schema: {
        type: :'object',
        properties: { "api_contact_activity": { type: :object, properties: {
          "title": { type: :string },
          "body": { type: :string },
          "date": { type: :string, format: :date },
          "activity_id": { type: :integer },
        } } },
      }
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
  path "/{account_id}/api/contacts/{contact_id}/contact_activities/new" do
    # You'll want to customize the parameter types...
    parameter name: "account_id", in: :path, type: :string, description: "account_id"
    parameter name: "contact_id", in: :path, type: :string, description: "contact_id"
    get("add contact activity") do
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

  path "/{account_id}/api/contacts/{contact_id}/contact_activities/{id}/edit" do
    # You'll want to customize the parameter types...
    parameter name: "account_id", in: :path, type: :string, description: "account_id"
    parameter name: "contact_id", in: :path, type: :string, description: "contact_id"
    parameter name: "id", in: :path, type: :string, description: "id"

    get("edit contact activity") do
      security [Bearer: {}]
      produces "application/json"
      consumes "application/json"
      response(200, "successful") do
        let(:contact_id) { "123" }
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
  path "/{account_id}/api/contacts/{contact_id}/contact_activities/{id}" do
    parameter name: "account_id", in: :path, type: :string, description: "account_id"
    parameter name: "contact_id", in: :path, type: :string, description: "contact_id"
    parameter name: "id", in: :path, type: :string, description: "id"
    patch("update contact activity") do
      security [Bearer: {}]
      produces "application/json"
      consumes "application/json"
      parameter name: :api_contact_activity, in: :body, schema: {
                  type: :'object',
                  properties: { "api_contact_activity": { type: :object, properties: {
                    "title": { type: :string },
                    "body": { type: :string },
                    "date": { type: :string, format: :date },
                  } } },
                }
      response(200, "successful") do
        let(:contact_id) { "123" }
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

    delete("delete contact activity") do
      security [Bearer: {}]
      produces "application/json"
      consumes "application/json"
      response(200, "successful") do
        let(:contact_id) { "123" }
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
