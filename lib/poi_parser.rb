# frozen_string_literal: true

# Data transformation: parsing methods for POIs
module PoiParser
  def self.coordinates(business, poi_list)
    poi_list.map do |poi|
      poi["position"]
    end.push(business_coordinates(business)).uniq # Just in case the bussines is not in the competition/nearBy results
  end

  def self.business_info(poi)
    {
      id: poi["id"],
      name: poi["poi"]["name"],
      address: poi["address"]["freeformAddress"],
      coordinates: poi["position"],
      phone: poi["poi"]["phone"]
    }
  end

  def self.categories(poi)
    poi["poi"]["categories"]
  end

  def self.category_set(business)
    business["poi"]["categorySet"]
  end

  def self.business_coordinates(business)
    business["position"]
  end
end
