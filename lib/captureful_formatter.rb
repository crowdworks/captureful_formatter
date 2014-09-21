require 'captureful_formatter/formatter'
require 'captureful_formatter/notifications'
require 'captureful_formatter/printer'
require 'captureful_formatter/version'

module CapturefulFormatter
  class << self
    attr_accessor :output_directory

    # what types to take screenshot
    #
    # @see http://rubydoc.info/gems/rspec-core/RSpec/Core/Metadata
    attr_accessor :target_type

    attr_accessor :template_name

    def configure
      yield self
    end

    def configuration
      self
    end
  end
end

CapturefulFormatter.configure do |c|
  c.output_directory = "./.captureful_formatter"
  c.target_type      = [:feature]
  c.template_name    = "test_report.html.erb"
end

require 'captureful_formatter/rspec_ext/rspec_core_reporter'
require 'captureful_formatter/turnip_ext/turnip_rspec_execute'
