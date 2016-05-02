# Traction

A Ruby wrapper of the <a href="https://tractiondigital.com/" target="_blank">Traction Digital</a> API. The wrapper contains only methods for endpoints for which previous access has been established. The addition of new methods when an API is created is encouraged.

Traction Digital <a href="https://int.tractionplatform.com/traction/help/int/webframe.html?Dynamic_API.html" target="_blank">API Documentation</a> requires an account and login. The documentation may be limited and/or out of date. Refer to the API Information associated with a particular function available in a specific campaign where possible for up to date information.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'traction'
```

And then execute:

    $ bundle

Or install it yourself using Rubygems:

    $ gem install traction

## Usage

Configure Traction with your API password and an object containing keys that become namespaces and paths associated with a "web connection" available to you in your Traction account. These paths are found in "API Information" in the Traction Account Dashboard, for a function within a given campaign. Note that the web connection path is only the part after "https://int.api.tractionplatform.com/". This will be something like "wkf/jo2nk2ejn7x4njens5wo".

The available methods in traction depend on the functions created in the traction dashboard for a given campaign. To confirm a method is available, ensure that a traction function exists with the method detailed in the API Information tab.

Using Rails, configuration can occur in an initializer:

```ruby
# config/initializers/traction.rb

Traction.configure("<your_api_password>", {competition:  "<web_connection_path>",
                                           registration: "<web_connection_path>",
                                           triggered:    "<web_connection_path>"}
```

Or, it could happen anywhere in your Ruby app before method call, either on app load or in a before hook will work fine.

Once you have completed configuration, use the gem methods to make api calls using the appropriate namespace you have created, associated with the traction function where that API is available:

```ruby
Traction.registration.get_customer_by("EMAIL", "example@email.com", ["EMAIL", "MOBILE", "FIRSTNAME", "LASTNAME"]
#=>
#{
#  data: {
#    customer: {
#      email: "example@email.com",
#      mobile: "0412345678",
#      firstname: "Jane",
#      lastname: "Doe"
#    }
#  },
#  success: true
#}
 
```

For the full list of available methods, refer to the <a href="http://www.rubydoc.info/gems/traction" target="_blank">documentation</a>.

## To Do
- provide some abstracted methods for removing subscriptions and groups etc
- add remaining methods when access is gained to new function in Traction Dashboard

## Contributing

Contributions are fully encouraged as the Traction API documentation does not reveal all available methods and new methods are available only when a function is available in the Traction Account dashboard. Simple wrappers and abstractions are welcome.

Particularly, given that traction functions exist for which no method has been made available yet, it is highly encouraged to add a method to this gem (using consistent style) if a user gains access to a function not yet wrapped by this gem.

1. Fork it ( https://github.com/hardhatdigital/traction/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
6. Party
