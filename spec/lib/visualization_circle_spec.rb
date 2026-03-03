# frozen_string_literal: true

require 'spec_helper'
require 'location'
require 'visualization_circle'

RSpec.describe VisualizationCircle do
  let(:coordinates) do
    [ { 'lat' => 51.507415, 'lon' => -0.140943 },
     { 'lat' => 51.521635, 'lon' => -0.151638 },
     { 'lat' => 51.51368, 'lon' => -0.086722 },
     { 'lat' => 51.532422, 'lon' => -0.125268 },
     { 'lat' => 51.535135, 'lon' => -0.103435 },
     { 'lat' => 51.51552, 'lon' => -0.18956 },
     { 'lat' => 51.5228, 'lon' => -0.075452 },
     { 'lat' => 51.5322, 'lon' => -0.0803 },
     { 'lat' => 51.546307, 'lon' => -0.074814 },
     { 'lat' => 51.562, 'lon' => -0.080045 } ]
  end

  describe '.calculate_circle' do
    context 'with valid coordinates' do
      it 'returns the expected circle' do
        circle = described_class.calculate_circle(coordinates)
        expect(circle).to match({
                                  center: Location.new(51.528911, -0.110818),
                                  radius: 0.079873
                                })
      end

      # This is not really necessary. It's a method I did to debug, and maybe it's useful in the future.
      it 'returns a valid circle' do
        circle = described_class.calculate_circle(coordinates)

        coordinates.each do |c|
          distance = described_class.calculate_distance(c['lon'], c['lat'], circle[:center].longitude,
                                                        circle[:center].latitude)

          inside = distance <= circle[:radius]
          expect(inside).to be(true)
        end
      end
    end
  end
end
