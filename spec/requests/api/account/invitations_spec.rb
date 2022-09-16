require "swagger_helper"

RSpec.describe "api/account/invitations", type: :request do
  path "/{account_id}/api/account/invitations" do
    parameter name: "account_id", in: :path, type: :string, description: "account_id"
    get("list invitations") do
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

    post("create invitation") do
      security [Bearer: {}]
      produces "application/json"
      consumes "application/json"
      parameter name: :api_invitation, in: :body, schema: {
        type: :'object',
        properties: { "api_invitation": { type: :object, properties: {
          "first_name": { type: :string },
          "last_name": { type: :string }, # optional
          "email": { type: :string }, # optional
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
  path "/{account_id}/api/account/invitations/{id}/activate" do
    # You'll want to customize the parameter types...
    parameter name: "account_id", in: :path, type: :string, description: "account_id"
    parameter name: "id", in: :path, type: :string, description: " invitation id"

    get("activate invitation") do
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
  path "/{account_id}/api/account/invitations/{id}/deactivate" do
    # You'll want to customize the parameter types...
    parameter name: "account_id", in: :path, type: :string, description: "account_id"
    parameter name: "id", in: :path, type: :string, description: " invitation id"

    get("deactivate invitation") do
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
