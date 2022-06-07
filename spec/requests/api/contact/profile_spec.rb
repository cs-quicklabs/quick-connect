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
end
