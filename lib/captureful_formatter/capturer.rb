require 'capybara'
require 'fileutils'
require 'pathname'

module CapturefulFormatter
  module Capturer
    class << self
      def init
        @dir = Pathname.new(CapturefulFormatter.configuration.output_directory)
        FileUtils.mkdir_p @dir
        @capturers = CapturefulFormatter.configuration.capturers
      end

      def capture step
        save_directory = @dir.join(step.scenario.hash, step.scenario.step_count.to_s)
        FileUtils.mkdir_p save_directory
        @capturers.each do |capturer|
          capturer.save_directory = save_directory
          step.captures[capturer.save_file] = capturer.save_path if capturer.capture
        end
      end

      def cleanup
        @capturers.each{|c| c.cleanup }
      end
    end

    # = How to make custom capturer
    #
    # 1. define capturer
    #
    # ```ruby
    # class MyCustomCapturer < CapturefulFormatter::Capturer::Base
    # end
    # ```
    #
    # 2. define capture method
    #
    # ```ruby
    # class MyCutomCapturer
    #   def capture
    #     // do it yourself.
    #   end
    # end
    # ```
    #
    # 3. add capturer
    #
    # ```ruby
    # CapturefulFormatter.configure do |c|
    #   c.capturers << MyCustomCapturer.new
    # end
    # ```
    #
    # 4. customize attributes
    #
    # you can override save_file method.
    #
    class Base
      attr_accessor :save_directory

      # constructor
      def initialize; end

      def save_file
        self.class.to_s
      end

      # path to save captured file
      def save_path
        save_directory.join(save_file)
      end

      def capture; end

      # cleanup method. this method called at test suites are finished.
      def cleanup; end
    end

    class ScreenShot < Base
      def save_file
        "ss.png"
      end

      def capture
        Capybara.current_session.save_screenshot save_path
      end
    end

    class Page < Base
      def save_file
        "page.html"
      end

      def capture
        Capybara.current_session.save_page save_path
      end
    end

    class LogFile < Base

      def initialize filename
        @filename = filename
        @io = File.open(filename, "r")
        @io.seek(0, IO::SEEK_END)
      end

      def save_file
        File.basename(@filename)
      end

      def capture
        File.write(save_path, @io.read)
      end

      def cleanup
        @io.close
      end
    end
  end
end
