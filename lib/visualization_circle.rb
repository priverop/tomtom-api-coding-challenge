# frozen_string_literal: true

require_relative "location"

## Calculate visualization circle
module VisualizationCircle
  def self.calculate_circle(coordinates)
    return if coordinates.nil?

    center = calculate_center(coordinates)
    radius = calculate_radius(center, coordinates)
    {
      center: center,
      radius: radius
    }
  end

  def self.calculate_center(coordinates)
    # longitud = x; latitud = y
    average_x = coordinates.sum { |c| c["lon"] } / coordinates.size
    average_y = coordinates.sum { |c| c["lat"] } / coordinates.size

    Location.new(average_y.round(6), average_x.round(6))
  end

  def self.calculate_radius(center, coordinates)
    coordinates.map do |c|
      calculate_distance(c["lon"], c["lat"], center.longitude, center.latitude)
    end.max.round(6)
  end

  # Pythagoras Theorem to get the distance between point A and point B
  def self.calculate_distance(a_x, a_y, b_x, b_y)
    Math.sqrt(((a_x - b_x)**2) + ((a_y - b_y)**2))
  end
end
