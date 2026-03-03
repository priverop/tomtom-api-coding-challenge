# frozen_string_literal: true

require "httparty"
require_relative "location"

# Service to consume TomTom Search API
class TomtomService
  include HTTParty

  base_uri "api.tomtom.com"

  COMPETITION_SEARCH_URL = "/search/2/nearbySearch"
  POI_SEARCH_URL = "/search/2/poiSearch"

  FUZZY_THRESHOLD = 0.8

  def initialize(business_name, location)
    @business_name = business_name
    @options = { query: { key: ENV.fetch("TOMTOM_API_KEY"), lat: location.latitude, lon: location.longitude,
                          limit: 10 } }

    validations!
  end

  def find_business
    response = self.class.get("#{POI_SEARCH_URL}/#{@business_name}.json", @options)
    # TODO: we should add timeouts management

    results = response.parsed_response["results"]

    return if results.nil? || results.empty?

    # The match should be higher than the threshold
    results.first["score"].to_f > FUZZY_THRESHOLD ? results.first : nil
  end

  def find_competition(category_set)
    add_category_options(category_set)

    # TODO: This might get the business POI as well. Should we remove it from the response?
    response = self.class.get("#{COMPETITION_SEARCH_URL}/.json", @options)
    response.parsed_response["results"]
  end

  private

  def add_category_options(category_set)
    category_id = category_set&.first&.[]("id")
    return if category_id.nil?

    @options[:query][:categorySet] = category_id
  end

  def validations!
    raise ArgumentError, "TOMTOM_API_KEY cannot be blank" if @options[:query][:key].empty?
  end
end
