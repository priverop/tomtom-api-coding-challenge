# Ruby code challenge
Welcome to Localistico’s recruitment process. We are very excited that you took the decision to
apply for this position. To make sure you are a good fit we want to propose this exercise. It will
not be long, promise.

The assignment is open-ended: getting everything done perfectly may take much more time
than we would expect someone to spend on a test assignment. Because of that, we expect the
result to be rough on the edges, minimum-viable-product version (MVP), so to speak. An
important part of any MVP is deciding what to focus on, what to ignore until the product is up
and running, and where to stop. We leave that decision up to you.

To give some more perspective, imagine this as a proof-of-concept project that will be passed
on to your teammate after the initial release. It is not worth it to polish it until it shines, but good
practices, such as meaningful variable names, conventional code structure, comments and
READMEs, would still help the hypothetical teammate to get up to speed with the codebase.

This assignment is divided into several steps. Please, read every step’s description carefully
before you start coding. Try to do as many steps as you can, and don’t worry if you are not able
to finish. Getting to the end is not a hard requirement. Just be prepared to talk about how you
would approach the missing parts during the next call where we will talk about this assignment.

You will have to upload the code to a Git repository that we will provide for you. Please, commit
your work in sizeable chunks so that the progress is easily visible.

Good Luck!

## Step 1: Use an External API

In Localistico, as in many companies nowadays, we use APIs all the time. That’s why you
should be able to use them and create them.

> [!WARNING]  
> for this step no third-party Ruby gems are allowed except a generic package to execute HTTP requests (Net::HTTP, Faraday, HTTParty or similar), just you, Ruby and the world of infinite possibilities out there.

### Here’s what you should do:

- Create a function or a method that accepts the following parameters:
    - a string containing the name of a business.
    - a location object with 2 attributes, latitude and longitude.
      
- Get *competition info* for a business (one place) described by these parameters with the help of the [TomTom Search API](https://developer.tomtom.com/search-api/documentation/search-service/search-service).
    - identify *the business* the user wanted to find among the returned results.
    - find 10 closest competing businesses (competing means same category/categories).
    
- Calculate *visualisation circle*: to show the info on the map, calculate a circle that covers *the business* and all its *competition*
    
- The result must contain the following:
    - *the business*: id, name, address, coordinates and phone number.
    - *categories*.
    - *visualisation circle*.
    
- Write some tests for this method.

## Step 2: Create an API Endpoint

At Localistico we use REST to connect different components of our architecture. For this reason, we also need to create our own APIs. The next exercise is to create a very simple API.
For this and all subsequent steps, you are allowed and even encouraged to use libraries or frameworks.

- The API will consist of one single method that will be accessible by a ​GET request to the endpoint ​`/get_competition_info`

- The endpoint should wrap the method implemented in Step 1.
  - it should accept the same parameters.
  - it should return the same result in JSON format.

- Validate all the inputs, if the validation fails, return an error:
  - name parameter should not be longer than 20 characters.
  - this endpoint should only support UK, any other country should return an error.
  - think about what other validations could you add here.

- Write some tests for the API.

> [!NOTE]  
> We expect this endpoint to be done in Ruby on Rails. Which testing libraries, other gems and which API design style you use is up to you!

## Step 3: Create a Web Interface (Optional)

To test your implementation, let’s add a web interface for the API.

- Create a web page for the API endpoint created in Step 2.
  - It should have fields to enter all the required parameters.
  - It should make a call to the API endpoint created in Step 2 and display the result/error.

- Write some tests for the web interface.

__Extra brownie points​ here if the solution also works without JS.__

______

### All done!

Congratulations if you made it until here! That’s all! Thank you very much for your effort! We hope you found the assignment interesting.

Now, make sure your changes are pushed to the repo, and email us to arrange the next call. Looking forward to talking more about your code! :)