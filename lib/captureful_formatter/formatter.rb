require 'capybara'
require 'digest/md5'
require 'fileutils'
require 'rspec/core'
require "rspec/core/formatters/base_formatter"

module CapturefulFormatter
  class Formatter < ::RSpec::Core::Formatters::BaseFormatter
    ::RSpec::Core::Formatters.register self, :start, :example_group_started, :example_group_finished,
                                             :example_started, :step_started, :example_passed, :example_pending, :example_failed, :stop

    Example = Struct.new("Example", :groups, :steps, :status, :fail_info)
    FailInfo = Struct.new("FailInfo", :exception, :backtraces)

    def start notification
      @should_capture = false
      @examples = {}
      @group_level = 0
      @group_examples = []
    end

    def example_group_started notification
      @should_capture = CapturefulFormatter.configuration.target_type.include? notification.group.metadata[:type]
      @group_level += 1
      @group_examples.push notification.group.description
    end

    def example_group_finished(notification)
      @should_capture = false
      @group_level -= 1
      @group_examples.pop
    end

    def example_started notification
      return unless @should_capture
      @current_example_hash = Digest::MD5.hexdigest(@group_examples.join())
      @examples[@current_example_hash] = Example.new(@group_examples.dup, [] , nil, nil)
    end

    def step_started notification
      save_step_sessions notification.description
    end

    def example_passed notification
      return unless @should_capture
      @examples[@current_example_hash].status = :passed
    end

    def example_pending notification
      return unless @should_capture
      @examples[@current_example_hash].status = :pending
    end

    def example_failed notification
      return unless @should_capture
      @examples[@current_example_hash].status = :failed
      @examples[@current_example_hash].fail_info = FailInfo.new(notification.exception.to_s, notification.formatted_backtrace.dup)
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

    def save_step_sessions step_description
      return unless @should_capture
      current_count = @examples[@current_example_hash].steps.size
      @examples[@current_example_hash].steps << step_description
      filename_base = report_save_dir.join("#{@current_example_hash}-#{current_count.to_s}")
      Capybara.current_session.save_page       filename_base.sub_ext(".html")
      Capybara.current_session.save_screenshot filename_base.sub_ext(".png")
    end

    def publish_reports
      FileUtils.copy_entry report_save_dir, CapturefulFormatter.configuration.output_directory
      CapturefulFormatter::Printer.print @examples
    end

    def cleanup_reports
      FileUtils.remove_entry_secure report_save_dir
    end
  end
end
