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

The available methods in traction depend on ...


# to do
- add remaining methods currently unavailable due to no existing endpoint
- documentation - usage examples and ruby docs gen
- totally should refactor to use sweet singleton/initializer approach
- provide some abstracted methods for removing subscriptions and groups etc

## Contributing

Contributions are fully encouraged as the Traction API documentation does not reveal all available methods and new methods are available only when a function is available in the Traction Account dashboard. Simple wrappers and abstractions are welcome.

1. Fork it ( https://github.com/hardhatdigital/traction/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
6. Party
