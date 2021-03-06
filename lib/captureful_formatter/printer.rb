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

      def path_to(captures, filename)
        captures[filename].to_s.gsub(/\.\/report\//, './')
      end
    end

    class << self
      attr_accessor :title

      def print(features)
        path = template_path
        params = {
          title: CapturefulFormatter.configuration.project_name,
          features: features
        }
        template = Template.new(params)
        filename = File.join(CapturefulFormatter.configuration.output_directory, "/index.html")
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
