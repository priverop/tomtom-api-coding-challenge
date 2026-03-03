# frozen_string_literal: true

require 'spec_helper'
require 'business_finder'
require 'location'

RSpec.describe BusinessFinder do
  describe '.find' do
    context 'with valid params' do
      it 'returns the business information' do
        VCR.use_cassette('business_finder/valid') do
          result = described_class.find('Fischers', Location.new('51.50', '-0.13'))
          expect(result).to match({
                                    business: {
                                      id: 'A7L3vzm0jzYbVT9rOSXMDQ',
                                      name: "Fischer's",
                                      address: '50 Marylebone High Street, London, W1U 5HN',
                                      coordinates: { 'lat' => 51.521635, 'lon' => -0.151638 },
                                      phone: '+44 20 7466 5501'
                                    },
                                    categories: %w[austrian restaurant],
                                    visualization_circle: { center: Location.new(51.528911, -0.110818),
                                                            radius: 0.079873 }
                                  })
        end
      end
    end

    context 'with invalid parameters' do
      it 'raises ArgumentError when business_name is empty' do
        expect do
          described_class.find('', '51.50')
        end.to raise_error(ArgumentError, 'business_name parameter cannot be blank')
      end

      it 'raises ArgumentError if business_name is not a string' do
        expect do
          described_class.find(123, '51.50')
        end.to raise_error(ArgumentError, 'business_name parameter must be a String')
      end
    end
  end
end
