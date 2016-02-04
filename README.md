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

The generator prompts for the following details to create ss2_config.rb:
1. Server name - It lists down the available Shield Square servers. Please choose the server closest to your region by selecting the option.
2. Sid - Enter the Subscriber Id available in your shield square account - https://admin.shieldsquare.com/subscriber_details/. Copy the Sandbox Id if it is Monitor mode or the Production Id for Active mode
3. Mode - Select the option to choose either Monitor or Active mode according to your Sid selection. If the selected mode is Monitor, async_http_post will be true by default else it is false

Once the above options are entered ss2_config.rb will be created inside config/initializers folder.

Update your view file with the code to access shield shquare API and JS snippet
