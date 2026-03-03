# Ruby code challenge

This is a code challenge I did for a Senior Ruby on Rails Engineer (which I passed!). The project was made in another repository, that's why there are not many commits.

## Requirements

This project runs with [Dev Containers](https://guides.rubyonrails.org/getting_started_with_devcontainer.html). Install [VS Code](https://code.visualstudio.com/), and the [Dev Containers Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers).

## How to

### Setup

After installing the Dev Containers extension in VSCode, run `Dev Containers: Build and Reopen in Container`.

Now add your **TomTom API KEY** to `config/environments/development.rb`.

### Competition Finder Interface

Start the Rails server with `rails server` and then open [http://localhost:3000/competition_finder/](http://localhost:3000/competition_finder/) in your browser.

### Testing

Inside the container with everything setup, lets run the tests:
- Run `bundle exec rspec` to see if everything is running smoothly. Every test should pass.
- Make sure you check the 100% code coverage with `open coverage/index.html`.

Now let's test the API ourselves:
- Make sure you added the API KEY.
- Run `rails server`.
- Using any API client (I suggest [Cartero](https://github.com/danirod/cartero)), request `http://localhost:3000/get_competition_info?business_name=Fischers&latitude=51.5&longitude=-0.13`.

> [!WARNING]
> Don't forget to add your **TomTom API KEY** to `config/environments/development.rb`.

## TomTom API

This project uses the [TomTom Search API](https://developer.tomtom.com/search-api/documentation/search-service/search-service), and you'll need to register to get a free API KEY.

To try and play around with these endpoints I used [Cartero](https://github.com/danirod/cartero). You can import the requests from the `docs/requests` directory.

## Testing

This library uses [VCR](https://yardoc.org/) for mocking the TomTom API calls. The first time it runs, it records all the requests and responses and stores them in `spec/fixtures/vcr_cassettes`. All the configuration is in `spec/spec_helper.rb`.

I replaced the *API_KEY* for a mockup string for [security](https://benoittgt.github.io/vcr/#/configuration/filter_sensitive_data).

## Security

I implemented a basic rate limiter with [rack-attack](https://github.com/rack/rack-attack) at `config/initializers/rack-attack.rb`.

## Improvements for this library
- [YARD](https://yardoc.org/) documentation.
- Automated tests in `pre-commit` with Git Hooks (I've always used [Overcommit](https://github.com/sds/overcommit)).