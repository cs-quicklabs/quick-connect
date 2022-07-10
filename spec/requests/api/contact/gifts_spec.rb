require "swagger_helper"

RSpec.describe "api/contact/gifts", type: :request do
  path "/{account_id}/api/contacts/{contact_id}/gifts?page={page}" do
    # You'll want to customize the parameter types...
    parameter name: "account_id", in: :path, type: :string, description: "account_id"
    parameter name: "contact_id", in: :path, type: :string, description: "contact_id"
    parameter name: "page", in: :path, type: :integer, description: "page"

    get("list gifts") do
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
  path "/{account_id}/api/contacts/{contact_id}/gifts" do
    post("create gift") do
      produces "application/json"
      consumes "application/json"
      parameter name: :api_gift, in: :body, schema: {
        type: :'object',
        properties: { "api_gift": { type: :object, properties: {
          "name": { type: :string },
          "body": { type: :string },
          "status": { type: :string, :example => [:given, :received] },
          "date": { type: :string, format: :date },
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

  path "/{account_id}/api/contacts/{contact_id}/gifts/{id}/edit" do
    # You'll want to customize the parameter types...
    parameter name: "account_id", in: :path, type: :string, description: "account_id"
    parameter name: "contact_id", in: :path, type: :string, description: "contact_id"
    parameter name: "id", in: :path, type: :string, description: "id"

    get("edit gift") do
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

  path "/{account_id}/api/contacts/{contact_id}/gifts/{id}" do
    # You'll want to customize the parameter types...
    parameter name: "account_id", in: :path, type: :string, description: "account_id"
    parameter name: "contact_id", in: :path, type: :string, description: "contact_id"
    parameter name: "id", in: :path, type: :string, description: "id"

    patch("update gift") do
      produces "application/json"
      consumes "application/json"
      parameter name: :api_gift, in: :body, schema: {
        type: :'object',
        properties: { "api_gift": { type: :object, properties: {
          "name": { type: :string },
          "body": { type: :string },
          "status": { type: :string, :example => [:given, :received] },
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

    delete("delete gift") do
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
