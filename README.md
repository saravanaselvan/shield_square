# ShieldSquare

Rails connector to access shield square bot detection API

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ss2', :git => "https://github.com/kvsrikanth/shield_square"
```
Run the bundle command to install the gem.

After you install the gem, run the generator:

``` 
rails generate ss2:install
```

The generator will install an initializer ss2_config.rb with default configuration to access shield square API.  Update the configuration file with your subscriber id, server etc.

Update your view file with the code to access shield shquare API and JS snippet
