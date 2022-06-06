require "swagger_helper"

RSpec.describe "api/contacts", type: :request do
  path "/api/archive/contacts" do
    get("archived contact") do
      consumes "application/json"
      produces "application/json",
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

  path "/api/archive/contact/{id}" do
    # You'll want to customize the parameter types...
    parameter name: "id", in: :path, type: :string, description: "id"

    get("archive_contact contact") do
      consumes "application/json"
      produces "application/json",
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

  path "/api/archive/contact/{id}/restore" do
    # You'll want to customize the parameter types...
    parameter name: "id", in: :path, type: :string, description: "id"

    get("unarchive_contact contact") do
      consumes "application/json"
      produces "application/json",
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

  path "/api/contacts" do
    get("list contacts") do
      consumes "application/json"
      produces "application/json",
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
      consumes "application/json"
      produces "application/json",
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

  path "/api/contacts/{id}/edit" do
    # You'll want to customize the parameter types...
    parameter name: "id", in: :path, type: :string, description: "id"

    get("edit contact") do
      produces "application/json"
      produces "application/json",
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

  path "/api/contacts/{id}" do
    # You'll want to customize the parameter types...
    parameter name: "id", in: :path, type: :string, description: "id"

    get("show contact") do
      produces "application/json"
      produces "application/json",
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
      produces "application/json"
      produces "application/json",
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

    put("update contact") do
      produces "application/json"
      produces "application/json",
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
