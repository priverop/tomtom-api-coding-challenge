# Architecture Decision Record

List and reasoning of my decisions building this project.

## Step 1: basic architecture

The library is designed following the Single Responsability principle.

- BusinessFinder is the method requested in the [Step 1 issue](https://github.com/localistico/ruby-code-challenge-pablo-rivero/issues/1). It acts as the Controller of the application.

- Location class is the requested Location Object. The idea would be to always use this class instead of a Hash of latitude and longitude.
- TomtomService. Isolated API communication.
- PoiParser: Data transformations to encapsulate TomTom API parameters. If the API changes, we only need to change the Service and this Parser. The _coordinates_ method could use the Location object for every coordinate. But I think it's overengineering it.
- VisualizationCircle is a module to calculate the circle. This could also be a Class, so we avoid working with hashes.
- We should maybe create a Business Class, to avoid working with hashes, and to remove most of the PoiParser logic.

### Bin/Run 

I always create a quick Ruby script to run the application, way before doing any tests. This allows me to design very quickly and let the right architecture emerge. I like using TDD when the feature is small and the architecture is done.

## Step 2: Create an API Endpoint

This API is generated using the Rails `new` command. I added `--devcontainer` to get the Docker setup and make the development and deployment way easier.

The old library is now in the `lib` folder. This makes a lot of sense because in the [Rails guide](https://guides.rubyonrails.org/getting_started.html#directory-structure) it says that the `lib` directory has the `Extended modules for your application`. Meaning all the code (domain logic) that is independant from the application logic. This is a nice case scenario to understand this.

If we migrated the app to another framework, the `lib` folder would be the same. It contains all the business logic, and services. Decoupled from the type of app we have: API, phone app, desktop app...

I really liked [this article](https://clayshentrup.medium.com/what-goes-in-rails-lib-92c74dfd955e) about this topic.

### Models and validations

At first I thought we could use Rails models with no database. This means inheriting from [ActiveModel](https://guides.rubyonrails.org/active_model_basics.html) rather than [ActiveRecord](https://guides.rubyonrails.org/active_record_basics.html).

With this, we could really benefit from the Validations system.

However, I don't think refactoring the whole thing to use Models fits into a MVP. I feel that the whole point of step 2 is not modifying the Step 1 library, and keep it as simple as possible.

### Validations

In the Step 2 we are required to add validations to the input parameters. But, I already added these validations to the BusinessFinder module.

I think we should keep both: the BusinessFinder handles the mandatory validations that make the library work. Then, the controller should handle all the extra requirements that we want for our API, such as the 20 chars limit.

The supported country validation is a special one. It should be at API level, because the library should support any country. However, adding this to BusinessFinder is very easy and clean. So, for the sake of a MVP, I added it there.