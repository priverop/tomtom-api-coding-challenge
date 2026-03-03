# spec/features/competition_interface_spec.rb
require 'rails_helper'

RSpec.describe 'Competition Interface', type: :system do
  before do
    visit '/competition_finder/index.html'
  end

  context 'when page loads with empty data' do
    it 'displays the form with all required fields' do
      visit '/competition_finder/index.html'

      expect(page).to have_title('Competition Finder')
      expect(page).to have_field('business_name')
      expect(page).to have_field('latitude')
      expect(page).to have_field('longitude')
      expect(page).to have_button('Get Competition Info')
    end

    it 'displays the empty iframe' do
      visit '/competition_finder/index.html'

      expect(page).to have_css('iframe[name="apiResponse"]')
      within_frame('apiResponse') do
        expect(page).to have_content('No results yet')
        expect(page).to have_content('Submit the form to see the results')
      end
    end
  end

  context 'when sending the form with valid data' do
    it 'form submits and returns json', :vcr do
      VCR.use_cassette('competition_finder/valid') do
        fill_in 'business_name', with: 'Fischers'
        fill_in 'latitude', with: '51.5'
        fill_in 'longitude', with: '-0.13'
        click_button 'Get Competition Info' # TODO: we should add ids, more robust

        within_frame('apiResponse') do
          expect(page).to have_content('visualization')
          expect(page).to have_no_content('No results yet')
        end
      end
    end
  end

  context 'when business does not exist' do
    it 'form submits and returns error', :vcr do
      VCR.use_cassette('competition_finder/business_not_found') do
        fill_in 'business_name', with: 'Test'
        fill_in 'latitude', with: '0'
        fill_in 'longitude', with: '0'
        click_button 'Get Competition Info' # TODO: we should add ids, more robust

        within_frame('apiResponse') do
          expect(page).to have_content('error')
          expect(page).to have_no_content('visualization')
        end
      end
    end
  end

  context 'when country is not supported' do
    it 'form submits and returns error', :vcr do
      VCR.use_cassette('competition_finder/country_not_supported') do
        fill_in 'business_name', with: 'Emiliano'
        fill_in 'latitude', with: '41.550562'
        fill_in 'longitude', with: '2.107687'
        click_button 'Get Competition Info' # TODO: we should add ids, more robust

        within_frame('apiResponse') do
          expect(page).to have_content('error')
          expect(page).to have_no_content('business')
        end
      end
    end
  end
end
