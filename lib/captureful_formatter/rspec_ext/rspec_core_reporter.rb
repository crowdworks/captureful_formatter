require 'rspec/core/reporter'

module CapturefulFormatter
  module RSpec
    module Core
      module Reporter
        def step_started(step)
          CapturefulFormatter::Notifications::StepNotification.from_step_object(step)
          notify :step_started, CapturefulFormatter::Notifications::StepNotification.from_step_object(step)
        rescue => e
          puts e
        end

        def step_finished(step)
          notify :step_finished, CapturefulFormatter::Notifications::StepNotification.from_step_object(step)
        end
      end
    end
  end
end

::RSpec::Core::Reporter.send(:prepend,  CapturefulFormatter::RSpec::Core::Reporter)
