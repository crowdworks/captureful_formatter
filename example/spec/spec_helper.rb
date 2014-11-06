require 'turnip'
require 'turnip/rspec'
require 'turnip/capybara'
require 'captureful_formatter'
require 'capybara'
require 'capybara/poltergeist'

require_relative '../web'

RSpec.configure do |config|
  config.add_formatter CapturefulFormatter::Formatter
  config.add_formatter 'progress'
end

Dir.glob("spec/**/*steps.rb") { |f| load f, true }

Capybara.app = Sinatra::Application.new
Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app, :js_errors => false, :timeout => 60)
end
Capybara.default_driver = :poltergeist
Capybara.javascript_driver = :poltergeist

CapturefulFormatter.configure do |c|
  c.project_name = "Example"
  c.output_directory = "./report"
end
