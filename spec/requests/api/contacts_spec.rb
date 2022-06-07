require "swagger_helper"

RSpec.describe "api/contacts", type: :request do
  path "/{account_id}/api/archive/contacts" do
    parameter name: "account_id", in: :path, type: :string, description: "account_id"
    get("archived contact") do
      response(200, "successful") do
        security [Bearer: {}]
        produces "application/json"
        consumes "application/json"

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

  path "/{account_id}/api/archive/contact/{id}" do
    # You'll want to customize the parameter types...
    parameter name: "id", in: :path, type: :string, description: "id"
    parameter name: "account_id", in: :path, type: :string, description: "account_id"
    get("archive_contact contact") do
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

  path "/{account_id}/api/archive/contact/{id}/restore" do
    # You'll want to customize the parameter types...
    parameter name: "id", in: :path, type: :string, description: "id"
    parameter name: "account_id", in: :path, type: :string, description: "account_id"
    get("unarchive_contact contact") do
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

  path "/{account_id}/api/contacts" do
    parameter name: "account_id", in: :path, type: :string, description: "account_id"
    get("list contacts") do
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

    post("create contact") do
      security [Bearer: {}]
      produces "application/json"
      consumes "application/json"
      parameter name: :api_contact, in: :body, schema: {
                  type: :'object',
                  properties: { "api_contact": { type: :object, properties: {
                    "first_name": { type: :string },
                    "last_name": { type: :string },
                    "phone": { type: :string },
                    "email": { type: :string },
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

  path "/{account_id}/api/contacts/{id}/edit" do
    parameter name: "account_id", in: :path, type: :string, description: "account_id"
    # You'll want to customize the parameter types...
    parameter name: "id", in: :path, type: :string, description: "id"

    get("edit contact") do
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

  path "/{account_id}/api/contacts/{id}" do
    parameter name: "account_id", in: :path, type: :string, description: "account_id"
    # You'll want to customize the parameter types...
    parameter name: "id", in: :path, type: :string, description: "id"

    get("show contact") do
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

    patch("update contact") do
      security [Bearer: {}]
      produces "application/json"
      consumes "application/json"
      parameter name: :api_contact, in: :body, schema: {
        type: :'object',
        properties: { "api_contact": { type: :object, properties: {
          "first_name": { type: :string },
          "last_name": { type: :string },
          "phone": { type: :string },
          "email": { type: :string },
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

    delete("delete contact") do
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
