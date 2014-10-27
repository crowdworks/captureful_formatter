require 'digest/md5'

module CapturefulFormatter

  # Data Structures for template files.
  module Structures
    class Feature
      attr_accessor :scenarios
      attr_accessor :description

      # [notification]
      #   GroupNotification
      def initialize(notification)
        @description = notification.group.description
        @scenarios = []
      end

      def all_passed
        @scenarios.count == num_passed
      end

      def num_passed
        @scenarios.count {|scenario| scenario.status == :passed }
      end

      def num_pending
        @scenarios.count {|scenario| scenario.status == :pending }
      end

      def num_failed
        @scenarios.count {|scenario| scenario.status == :failed }
      end
    end

    class Scenario
      attr_accessor :steps
      attr_accessor :description
      attr_accessor :status
      attr_accessor :exception

      # [notification]
      #   ExampleNotification
      def initialize(notification)
        @steps = []
        @status = nil
        @description = notification.group.description
        @exception = nil
        feature_description = notification.group.metadata[:parent_example_group][:description]
        @hash = Digest::MD5.hexdigest("#{feature_description}#{notification.group.description}")
      end

      def hash
        @hash
      end

      def step_count
        @steps.size
      end
    end

    class Step
      attr_accessor :description

      # [notification]
      #   StepNotification
      def initialize(notification)
        @description = notification.description
      end
    end
  end
end
