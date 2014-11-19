# CapturefulFormatter

[![Gem Version](https://badge.fury.io/rb/captureful_formatter.svg)](http://badge.fury.io/rb/captureful_formatter)[![Code Climate](https://codeclimate.com/github/crowdworks/captureful_formatter/badges/gpa.svg)](https://codeclimate.com/github/crowdworks/captureful_formatter)
[![Build Status](https://travis-ci.org/crowdworks/captureful_formatter.svg)](https://travis-ci.org/crowdworks/captureful_formatter)
[![Code Climate](https://codeclimate.com/github/crowdworks/captureful_formatter/badges/gpa.svg)](https://codeclimate.com/github/crowdworks/captureful_formatter)
[![Coverage Status](https://coveralls.io/repos/crowdworks/captureful_formatter/badge.png?branch=master)](https://coveralls.io/r/crowdworks/captureful_formatter?branch=master)
[![Dependency Status](https://gemnasium.com/crowdworks/captureful_formatter.svg)](https://gemnasium.com/crowdworks/captureful_formatter)

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

## Sample

![output sample](https://github.com/crowdworks/captureful_formatter/blob/master/sample.png)

## Configuration

```ruby
CapturefulFormatter.configure do |config|
  config.project_name = "Your Project" # Title of test report
  config.output_directory = "./.captureful_formatter" # The path to where the test report is saved.
  config.template_path = "path/to/template" # your custom template file path.
end
```

now, captureful_formatter support erb template only.

## Contributing

1. Fork it ( https://github.com/ayasuda/captureful_formatter/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
