require 'selenium-webdriver'

Capybara.register_driver :remote_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')

  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    # SELENIUM_HOST: in CI is 'localhost', in Devcontainer is 'selenium'
    url: "http://#{ENV.fetch('SELENIUM_HOST', 'localhost')}:4444/wd/hub",
    options: options
  )
end
