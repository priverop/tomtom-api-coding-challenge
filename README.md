# Ruby code challenge

## Requirements

Either install [VS Code](https://code.visualstudio.com/), and the [Dev Containers Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers).

Or install docker manually:
- [Docker Engine](https://docs.docker.com/engine/install/). Or any Docker UI manager such as [Rancher Desktop](https://rancherdesktop.io/).
- [Docker compose](https://docs.docker.com/compose/).

## How to

### Setup

This project comes with [Dev Containers](https://guides.rubyonrails.org/getting_started_with_devcontainer.html) setup. If you use VS Code you can install the [extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) and then run `Dev Containers: Reopen in Container`.

You can also run it manually with Docker Compose:

```bash
docker compose -f .devcontainer/docker-compose.yml build
docker compose -f .devcontainer/docker-compose.yml up
```

Get into the machine with `docker compose exec app bash` and then set up the project with `bin/setup --skip-server`.

Now add your **TomTom API KEY** to `config/environments/development.rb`.

### Testing

Inside the container with everything setup, lets run the tests:
- Run `bundle exec rspec` to see if everything is running smoothly. Every test should pass.
- Make sure you check the 100% code coverage with `open coverage/index.html`.

Now let's test the API ourselves:
- Make sure you added the API KEY.
- Run `rails server`.
- Using any API client (I suggest [Cartero](github.com/danirod/cartero)), request `http://localhost:3000/get_competition_info?business_name=Fischers&latitude=51.5&longitude=-0.13`.

> [!WARNING]
> Don't forget to add your **TomTom API KEY** to `config/environments/development.rb`.

## TomTom API

This project uses the [TomTom Search API](https://developer.tomtom.com/search-api/documentation/search-service/search-service), and you'll need to register to get a free API KEY.

To try and play around with these endpoints I used [Cartero](https://github.com/danirod/cartero). You can import the requests from the `docs/requests` directory.

## Testing

This library uses [VCR](https://yardoc.org/) for mocking the TomTom API calls. The first time it runs, it records all the requests and responses and stores them in `spec/fixtures/vcr_cassettes`. All the configuration is in `spec/spec_helper.rb`.

I replaced the *API_KEY* for a mockup string for [security](https://benoittgt.github.io/vcr/#/configuration/filter_sensitive_data).

## Security

I implemented a basic rate limiter with [rack-attack](github.com/rack/rack-attack) at `config/initializers/rack-attack.rb`.

## Improvements for this library
- [YARD](https://yardoc.org/) documentation.
- Automated tests in `pre-commit` with Git Hooks (I've always used [Overcommit](https://github.com/sds/overcommit)).
- Add [rack-cors](https://github.com/cyu/rack-cors) for more security.