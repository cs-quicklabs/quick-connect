RSpec.describe "api/invitations", type: :request do
  path "/api/invitations" do
    post("change password and accept invitation") do
      produces "application/json"
      consumes "application/json"
      parameter name: :resource, in: :body, schema: {
                  type: :'object',
                  properties: { "api_user": { type: :object, properties: {
                    "password": { type: :string },
                    "password_confirmation": { type: :string },
                    "invitation_token": { type: :string },
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
end
