require 'capybara'
require 'fileutils'
require 'pathname'

module CapturefulFormatter
  module Capturer
    class << self
      def init
        @dir = Pathname.new(CapturefulFormatter.configuration.output_directory)
        FileUtils.mkdir_p @dir
        @capturers =CapturefulFormatter.configuration.capturers
      end

      def capture hash, count
        save_directory = @dir.join(hash, count.to_s)
        FileUtils.mkdir_p save_directory
        @capturers.each do |capturer|
          capturer.capture(save_directory)
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
    class Base
      # constructor
      def initialize; end

      # 
      def capture dir; end

      # cleanup method. this method called at test suites are finished.
      def cleanup; end
    end

    class ScreenShot < Base
      def capture dir
        Capybara.current_session.save_screenshot dir.join("ss").sub_ext(".png")
      end
    end

    class Page < Base
      def capture dir
        Capybara.current_session.save_page dir.join("page").sub_ext(".html")
      end
    end
  end
end
