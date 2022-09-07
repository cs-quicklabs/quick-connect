RSpec.describe "api/invitations", type: :request do
  path "/api/invitations?invitation_token={invitation_token}" do
    parameter name: "invitation_token", in: :path, type: :string, description: "invitation_token"
    post("change password and login") do
      produces "application/json"
      consumes "application/json"
      parameter name: :api_user, in: :body, schema: {
                  type: :'object',
                  properties: { "api_user": { type: :object, properties: {
                    "password": { type: :string },
                    "password_confirmation": { type: :string },
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
