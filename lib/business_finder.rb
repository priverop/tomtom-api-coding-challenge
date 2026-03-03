# frozen_string_literal: true

require_relative "visualization_circle"
require_relative "location"
require_relative "poi_parser"
require_relative "tomtom_service"

# Controller for the Step1
module BusinessFinder
  class CountryNotSupportedError < StandardError; end
  class BusinessNotFoundError < StandardError; end

  SUPPORTED_COUNTRY = "GB"

  def self.find(business_name, location)
    validate_params!(business_name, location)

    service = TomtomService.new(business_name, location)

    business = service.find_business

    validate_business!(business)

    business_finder_result(service, business)
  end

  def self.business_finder_result(service, business)
    competition = service.find_competition(PoiParser.category_set(business))
    coordinates = PoiParser.coordinates(business, competition)
    circle = VisualizationCircle.calculate_circle(coordinates)
    {
      business: PoiParser.business_info(business),
      categories: PoiParser.categories(business),
      visualization_circle: circle
    }
  end

  def self.validate_params!(business_name, location)
    raise ArgumentError, "business_name parameter cannot be blank" if business_name.to_s.empty?
    raise ArgumentError, "business_name parameter must be a String" unless business_name.is_a?(String)
    raise ArgumentError, "location parameter must be a Location object" unless location.is_a?(Location)
  end

  def self.validate_business!(business)
    raise BusinessNotFoundError, "business not found, please change your input" if business.nil?
    raise CountryNotSupportedError, "only the UK is supported, please change your coordinates" unless business["address"]["countryCode"] == SUPPORTED_COUNTRY
  end
end
