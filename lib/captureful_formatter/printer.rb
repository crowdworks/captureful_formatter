require 'erb'
require 'ostruct'

module CapturefulFormatter
  module Printer
    class Template < OpenStruct
      def render(template)
        ERB.new(template).result(binding)
      end

      def background_by_status(status)
        case status
        when :passed then "bg-success"
        when :pending then "bg-warning"
        when :failed then "bg-danger"
        else "bg-info"
        end
      end
    end

    class << self
      attr_accessor :title

      def print examples
        # FIXME: choosable user specified directory or gem's templates dierectory
        path = File.dirname(__FILE__) + "/../../templates/" + CapturefulFormatter.configuration.template_name
        params = {
          title: "test report",
          examples: examples
        }
        template = Template.new(params)
        filename = CapturefulFormatter.configuration.output_directory + "/index.html"
        File.write(filename ,template.render(File.read(path)))
      end
    end
  end
end
