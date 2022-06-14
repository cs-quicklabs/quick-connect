require "swagger_helper"

RSpec.describe "api/user", type: :request do
  path "/{account_id}/api/user/{id}" do
    # You'll want to customize the parameter types...
    parameter name: "account_id", in: :path, type: :string, description: "account_id"

    patch("update user") do
      security [Bearer: {}]
      produces "application/json"
      consumes "application/json"
      parameter name: :api_user, in: :body, schema: {
        type: :'object',
        properties: { "api_user": { type: :object, properties: {
          "first_name": { type: :string },
          "last_name": { type: :string },
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

    path "/{account_id}/api/settings/profile" do
      parameter name: "account_id", in: :path, type: :string, description: "account_id"
      get("profile user") do
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

    path "/{account_id}/api/settings/password" do
      parameter name: "account_id", in: :path, type: :string, description: "account_id"
      patch("update password user") do
        security [Bearer: {}]
        produces "application/json"
        consumes "application/json"
        parameter name: :api_user, in: :body, schema: {
          type: :'object',
          properties: { "api_user": { type: :object, properties: {
            "original_password": { type: :string },
            "new_password": { type: :string },
            "new_password_confirmation": { type: :string },
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
    path "/{account_id}/api/settings/permission" do
      parameter name: "account_id", in: :path, type: :string, description: "account_id"
      patch("update email notification user") do
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
    path "/{account_id}/api/settings/preferences" do
      parameter name: "account_id", in: :path, type: :string, description: "account_id"
      get("preferences user") do
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
  end
end
