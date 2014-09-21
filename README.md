# CapturefulFormatter

Yet another custom formatter for [Turnip](https://github.com/jnicklas/turnip). Saving screenshots and pages each steps.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'captureful_formatter'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install captureful_formatter

Now edit the .rspec file in your project directory (create it if doesn't exist), and add the following line:

    -r captureful_formatter
    -f CapturefulFormatter::Formatter

## Usage

Run this command.

    $ rspec

## Contributing

1. Fork it ( https://github.com/ayasuda/captureful_formatter/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
