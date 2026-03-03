# frozen_string_literal: true

require_relative "../../lib/business_finder"
require_relative "../../lib/location"

# Controller for the Step 2
class CompetitionController < ApplicationController
  MAX_BUSINESS_NAME_LENGTH = 20

  rescue_from ArgumentError, with: :handle_missing_params
  rescue_from BusinessFinder::CountryNotSupportedError, with: :handle_not_supported
  rescue_from BusinessFinder::BusinessNotFoundError, with: :handle_not_supported

  # GET /get_competition_info?business_name=value&latitude=51.03&longitude=-0.12
  # Get the Competition Info.
  # Parameters: business_name, latitude and longitude.
  def get_competition_info
    business_name_param = params[:business_name]
    latitude_param = params[:latitude]
    longitude_param = params[:longitude]

    # The library already has basic validations for the
    validate!(business_name_param, latitude_param, longitude_param)

    # We don't clean the parameters because we are querying an external API with them. And the API has all the security measures.
    result = BusinessFinder.find(business_name_param, Location.new(latitude_param.to_f, longitude_param.to_f))

    render json: result
  end

  private

  # TODO: separate into two different methods
  def validate!(business_name, lat, lon)
    # business_name
    raise ArgumentError, "business_name cannot be empty" if business_name.nil?
    raise ArgumentError, "business_name cannot be blank or only whitespace" if business_name.strip.empty?
    raise ArgumentError, "business_name parameter cannot be longer than 20 characters" if business_name.size > MAX_BUSINESS_NAME_LENGTH
    # lat and lon
    raise ArgumentError, "latitude cannot be empty" if lat.nil?
    raise ArgumentError, "longitude cannot be empty" if lon.nil?
    begin
      lat_f = Float(lat)
      lon_f = Float(lon)
    rescue ArgumentError, TypeError
      raise ArgumentError, "latitude and longitude must be valid numbers"
    end
    raise ArgumentError, "latitude must be between -90 and 90" unless lat_f.between?(-90, 90)
    raise ArgumentError, "longitude must be between -180 and 180" unless lon_f.between?(-180, 180)
  end

  def handle_missing_params(exception)
    render json: { error: exception.message }, status: :bad_request
  end

  def handle_not_supported(exception)
    render json: { error: exception.message }, status: :unprocessable_content
  end
end
