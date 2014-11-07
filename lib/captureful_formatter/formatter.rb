require 'capybara'
require 'rspec/core'
require "rspec/core/formatters/base_formatter"

module CapturefulFormatter
  class Formatter < ::RSpec::Core::Formatters::BaseFormatter
    ::RSpec::Core::Formatters.register self, :start, :example_group_started, :example_group_finished,
                                             :example_started, :step_finished, :example_passed, :example_pending, :example_failed, :stop

    def start notification
      @should_capture = false
      @current_feature = nil
      @features = []
      Capturer.init
    end

    def example_group_started notification
      if notification.group.metadata[:parent_example_group].nil?
        return unless (@should_capture = type_included? notification.group.metadata[:type])
        @current_feature = Structures::Feature.new(notification)
      else
        @current_scenario = Structures::Scenario.new(notification)
      end
    end

    def example_group_finished(notification)
      return unless @should_capture
      if notification.group.metadata[:parent_example_group].nil?
        @features.push @current_feature
        @should_capture = false
        @current_feature = nil
      else
        @current_feature.scenarios.push @current_scenario
      end
    end

    def example_started notification
      return unless @should_capture
    end

    def step_finished notification
      return unless @should_capture
      @current_scenario.steps.push Structures::Step.new(notification)
      Capturer.capture @current_scenario.hash, @current_scenario.step_count
    end

    def example_passed notification
      return unless @should_capture
      @current_scenario.status = :passed
    end

    def example_pending notification
      return unless @should_capture
      @current_scenario.status = :pending
    end

    def example_failed notification
      return unless @should_capture
      @current_scenario.status = :failed
      @current_scenario.exception = notification.exception
    end

    def stop notification
      publish_reports
    rescue => e
      CapturefulFormatter.configuration.logger.error e.to_s
    ensure
      Capturer.cleanup
    end

  private

    def type_included? type
      CapturefulFormatter.configuration.target_type.include? type
    end

    def publish_reports
      Printer.print @features
    end
  end
end
