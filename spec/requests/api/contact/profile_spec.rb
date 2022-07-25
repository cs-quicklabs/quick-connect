require "swagger_helper"

RSpec.describe "api/contact/profile", type: :request do
  path "/{account_id}/api/contacts/{contact_id}/profile" do
    # You'll want to customize the parameter types...
    parameter name: "account_id", in: :path, type: :string, description: "account_id"
    parameter name: "contact_id", in: :path, type: :string, description: "contact_id"

    get("contact profile") do
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
  path "/{account_id}/api/contacts/{contact_id}/label/{label_id}" do
    # You'll want to customize the parameter types...
    parameter name: "account_id", in: :path, type: :string, description: "account_id"
    parameter name: "contact_id", in: :path, type: :string, description: "contact_id"
    parameter name: "label_id", in: :path, type: :string, description: "label_id"

    get("contact profile") do
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
  path "/{account_id}/api/contacts/{contact_id}/remove_label/{label_id}" do
    # You'll want to customize the parameter types...
    parameter name: "account_id", in: :path, type: :string, description: "account_id"
    parameter name: "contact_id", in: :path, type: :string, description: "contact_id"
    parameter name: "label_id", in: :path, type: :string, description: "label_id"

    get("contact profile") do
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
  path "/{account_id}/api/contacts/{contact_id}/relation/{relation_id}" do
    # You'll want to customize the parameter types...
    parameter name: "account_id", in: :path, type: :string, description: "account_id"
    parameter name: "contact_id", in: :path, type: :string, description: "contact_id"
    parameter name: "relation_id", in: :path, type: :string, description: "relation_id"

    get("contact profile") do
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
  path "/{account_id}/api/contacts/{contact_id}/remove_relation" do
    # You'll want to customize the parameter types...
    parameter name: "account_id", in: :path, type: :string, description: "account_id"
    parameter name: "contact_id", in: :path, type: :string, description: "contact_id"

    get("contact profile") do
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

  path "/{account_id}/api/contacts/{contact_id}/favorite" do
    # You'll want to customize the parameter types...
    parameter name: "account_id", in: :path, type: :string, description: "account_id"
    parameter name: "contact_id", in: :path, type: :string, description: "contact_id"

    get("add contact as favorite") do
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
end
