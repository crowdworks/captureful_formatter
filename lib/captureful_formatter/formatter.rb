require 'capybara'
require 'fileutils'
require 'rspec/core'
require "rspec/core/formatters/base_formatter"

module CapturefulFormatter
  class Formatter < ::RSpec::Core::Formatters::BaseFormatter
    ::RSpec::Core::Formatters.register self, :start, :example_group_started, :example_group_finished,
                                             :example_started, :step_started, :example_passed, :example_pending, :example_failed, :stop

    FailInfo = Struct.new("FailInfo", :exception, :backtraces)

    def start notification
      @should_capture = false
      @features = []
    end

    def example_group_started notification
      if notification.group.metadata[:parent_example_group].nil?
        @should_capture = CapturefulFormatter.configuration.target_type.include? notification.group.metadata[:type]
        @current_feature = CapturefulFormatter::Structures::Feature.new(notification)
      else
        @current_scenario = CapturefulFormatter::Structures::Scenario.new(notification)
      end
    end

    def example_group_finished(notification)
      if notification.group.metadata[:parent_example_group].nil?
        @features.push @current_feature
        @should_capture = false
      else
        @current_feature.scenarios.push @current_scenario
      end
    end

    def example_started notification
      return unless @should_capture
    end

    def step_started notification
      return unless @should_capture
      @current_scenario.steps.push CapturefulFormatter::Structures::Step.new(notification)
      save_step_sessions
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
      cleanup_reports
    end

  private

    def report_save_dir
      @dir ||= Pathname.new(Dir.mktmpdir ["d", self.object_id.to_s ])
    end

    def save_step_sessions
      return unless @should_capture
      filename_base = report_save_dir.join("#{@current_scenario.hash}-#{@current_scenario.step_count.to_s}")
      Capybara.current_session.save_page       filename_base.sub_ext(".html")
      Capybara.current_session.save_screenshot filename_base.sub_ext(".png")
    end

    def publish_reports
      FileUtils.copy_entry report_save_dir, CapturefulFormatter.configuration.output_directory
      CapturefulFormatter::Printer.print @features
    end

    def cleanup_reports
      FileUtils.remove_entry_secure report_save_dir
    end
  end
end
