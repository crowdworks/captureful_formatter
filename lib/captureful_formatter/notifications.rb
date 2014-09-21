module CapturefulFormatter
  module Notifications
    StepNotification = Struct.new(:description, :keyword, :extra_args) do
      private_class_method :new

      # @api
      def self.from_step_object(data)
        new data.description, data.keyword, data.extra_args
      end
    end
  end
end
