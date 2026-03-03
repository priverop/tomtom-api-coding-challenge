require "capybara/rspec"
require "selenium-webdriver"

# Allow Selenium and Capybara connections through VCR
VCR.configure do |config|
  config.ignore_localhost = true
  if ENV["SELENIUM_HOST"].present?
    config.ignore_hosts ENV["SELENIUM_HOST"]
  end
end

# Allow Selenium and localhost connections through WebMock
WebMock.disable_net_connect!(
  allow_localhost: true,
  allow: [ENV["SELENIUM_HOST"]].compact
)

Capybara.register_driver :custom_headless_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument("--headless=new")
  options.add_argument("--no-sandbox")
  options.add_argument("--disable-dev-shm-usage")
  options.add_argument("--disable-gpu")
  options.add_argument("--window-size=1400,900")

  if ENV["SELENIUM_HOST"].present?
    Capybara::Selenium::Driver.new(
      app,
      browser: :remote,
      url: "http://#{ENV['SELENIUM_HOST']}:4444",
      options: options
    )
  else
    Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
  end
end

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :custom_headless_chrome

    if ENV["SELENIUM_HOST"].present?
      # Capybara server must be accessible from the Selenium container
      Capybara.server_host = "0.0.0.0"
      Capybara.server_port = ENV.fetch("CAPYBARA_SERVER_PORT", 45678).to_i
      Capybara.app_host = "http://#{`hostname`.strip}:#{Capybara.server_port}"
    end
  end
end
