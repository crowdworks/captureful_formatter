require 'erb'
require 'ostruct'

module CapturefulFormatter
  module Printer
    class TemplateMissingError < StandardError; end

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
        path = template_path
        params = {
          title: "test report",
          examples: examples
        }
        template = Template.new(params)
        filename = CapturefulFormatter.configuration.output_directory + "/index.html"
        File.write(filename ,template.render(File.read(path)))
      end

      def template_path
        path = CapturefulFormatter.configuration.template_path
        path = File.absolute_path(path)
        raise TemplateMissingError, path unless File.exists? path

        path
      end
    end
  end
end
