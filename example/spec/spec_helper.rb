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

class CustomCapturer < CapturefulFormatter::Capturer::Base
  def save_file
    "custom_file"
  end

  def capture
    File.write(save_path, Time.now.to_s)
  end
end

CapturefulFormatter.configure do |c|
  c.project_name = "Example"
  c.output_directory = "./report"
  c.capturers << CustomCapturer.new
end
