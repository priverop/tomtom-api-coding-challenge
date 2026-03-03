# frozen_string_literal: true

# Location object. Position of a POI in a map.
class Location
  attr_reader :latitude, :longitude

  def initialize(lat, lon)
    @latitude = lat
    @longitude = lon
  end

  def ==(other)
    return false unless other.is_a?(Location)

    latitude == other.latitude && longitude == other.longitude
  end
end
