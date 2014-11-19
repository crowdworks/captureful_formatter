require 'turnip/rspec'

module CapturefulFormatter
  module Turnip
    module RSpec
      module Execute
        def run_step(feature_file, step)
          reporter = ::RSpec.configuration.reporter
          reporter.step_started(step)
          super(feature_file, step)
        ensure
          reporter.step_finished(step)
        end
      end
    end
  end
end

::Turnip::RSpec::Execute.class_eval { prepend(CapturefulFormatter::Turnip::RSpec::Execute) }
