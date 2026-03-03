# spec/requests/competition_spec.rb
require 'rails_helper'

RSpec.describe "Competition Controller", type: :request do
  describe "GET /get_competition_info" do
    let(:valid_params) do
      {
        business_name: "Fischers",
        latitude: "51.50",
        longitude: "-0.13"
      }
    end

    context "with valid parameters" do
      it "returns success and competition info", :vcr do
        VCR.use_cassette('competition_controller/valid') do
          get get_competition_info_path, params: valid_params

          expect(response).to have_http_status(:success)

          expect(response.parsed_body).to match({
                                    business: {
                                      id: 'A7L3vzm0jzYbVT9rOSXMDQ',
                                      name: "Fischer's",
                                      address: '50 Marylebone High Street, London, W1U 5HN',
                                      coordinates: { 'lat' => 51.521635, 'lon' => -0.151638 },
                                      phone: '+44 20 7466 5501'
                                    },
                                    categories: %w[austrian restaurant],
                                    visualization_circle: { 'center' => { 'latitude' => 51.528911, 'longitude' => -0.110818 },
                                                            'radius' => 0.079873 }
                                  })
        end
      end
    end

    context "with missing business_name" do
      it "returns bad request" do
        get get_competition_info_path, params: { latitude: "51.03", longitude: "-0.12" }
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq({ "error" => "business_name cannot be empty" })
      end
    end

    context "with missing latitude" do
      it "returns bad request with error message" do
        get get_competition_info_path, params: { business_name: "Test", longitude: "-0.12" }
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq({ "error" => "latitude cannot be empty" })
      end
    end

    context "with missing longitude" do
      it "returns bad request with error message" do
        get get_competition_info_path, params: { business_name: "Test", latitude: "51.03" }
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq({ "error" => "longitude cannot be empty" })
      end
    end

    context "when latitude is not a number" do
      it "returns bad request" do
        get get_competition_info_path, params: valid_params.merge(latitude: "abc")

        expect(response).to have_http_status(:bad_request)
        expect(response.parsed_body).to eq(
          { "error" => "latitude and longitude must be valid numbers" }
        )
      end
    end

    context "when longitude is not a number" do
      it "returns bad request" do
        get get_competition_info_path, params: valid_params.merge(longitude: "xyz")

        expect(response).to have_http_status(:bad_request)
        expect(response.parsed_body).to eq(
          { "error" => "latitude and longitude must be valid numbers" }
        )
      end
    end

    context "when latitude is out of range" do
      it "returns bad request" do
        get get_competition_info_path, params: valid_params.merge(latitude: "91")

        expect(response).to have_http_status(:bad_request)
        expect(response.parsed_body).to eq(
          { "error" => "latitude must be between -90 and 90" }
        )
      end
    end

    context "when longitude is out of range" do
      it "returns bad request" do
        get get_competition_info_path, params: valid_params.merge(longitude: "181")

        expect(response).to have_http_status(:bad_request)
        expect(response.parsed_body).to eq(
          { "error" => "longitude must be between -180 and 180" }
        )
      end
    end

    context "when business_name is only whitespace" do
      it "returns bad request" do
        get get_competition_info_path, params: valid_params.merge(business_name: "   ")

        expect(response).to have_http_status(:bad_request)
        expect(response.parsed_body).to eq(
          { "error" => "business_name cannot be blank or only whitespace" }
        )
      end
    end

    context "with business_name longer than 20 characters" do
      it "returns bad request with error message" do
        long_name = "TomTomApiTomTomApi"
        get get_competition_info_path, params: valid_params.merge(business_name: long_name)
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq({ "error" => "business_name parameter cannot be longer than 20 characters" })
      end
    end

    context "when country is not supported" do
      it "returns unprocessable entity", :vcr do
        VCR.use_cassette('competition_controller/country_not_supported') do
          get get_competition_info_path, params: { business_name: "Emiliano", latitude: "41.550562", longitude: "2.107687" }

          expect(response).to have_http_status(:unprocessable_content)
          expect(JSON.parse(response.body)).to have_key("error")
        end
      end
    end

    context "when business is not found" do
      it "returns unprocessable entity", :vcr do
        VCR.use_cassette('competition_controller/business_not_found') do
          get get_competition_info_path, params: { business_name: "Test", latitude: "0", longitude: "0" }

          expect(response).to have_http_status(:unprocessable_content)
          expect(JSON.parse(response.body)).to have_key("error")
        end
      end
    end
  end
end
