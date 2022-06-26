require "swagger_helper"

RSpec.describe "api/contact/notes", type: :request do
  path "/{account_id}/api/contacts/{contact_id}/notes?page={page}" do
    # You'll want to customize the parameter types...
    parameter name: "account_id", in: :path, type: :string, description: "account_id"
    parameter name: "contact_id", in: :path, type: :string, description: "contact_id"
    parameter name: "page", in: :path, type: :integer, description: "page"

    get("list notes") do
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

    post("create note") do
      security [Bearer: {}]
      produces "application/json"
      consumes "application/json"
      parameter name: :api_note, in: :body, schema: {
        type: :'object',
        properties: { "api_note": { type: :object, properties: {
          "title": { type: :string },
          "body": { type: :string },
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

  path "/{account_id}/api/contacts/{contact_id}/notes/{id}/edit" do
    # You'll want to customize the parameter types...
    parameter name: "account_id", in: :path, type: :string, description: "account_id"
    parameter name: "contact_id", in: :path, type: :string, description: "contact_id"
    parameter name: "id", in: :path, type: :string, description: "id"

    get("edit note") do
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

  path "/{account_id}/api/contacts/{contact_id}/notes/{id}" do
    # You'll want to customize the parameter types...
    parameter name: "account_id", in: :path, type: :string, description: "account_id"
    parameter name: "contact_id", in: :path, type: :string, description: "contact_id"
    parameter name: "id", in: :path, type: :string, description: "id"

    patch("update note") do
      security [Bearer: {}]
      produces "application/json"
      consumes "application/json"
      parameter name: :api_note, in: :body, schema: {
        type: :'object',
        properties: { "api_note": { type: :object, properties: {
          "title": { type: :string },
          "body": { type: :string },
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

    delete("delete note") do
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
