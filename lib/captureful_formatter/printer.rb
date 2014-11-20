require 'erb'
require 'ostruct'

module CapturefulFormatter
  module Printer
    class TemplateMissingError < StandardError; end

    class Base
      attr_accessor :template_path

      def print params; end
    end


    class << self
      attr_accessor :title

      def print(features)
        printer = CapturefulFormatter.configuration.printer.new
        printer.template_path = template_path
        params = {
          title: CapturefulFormatter.configuration.project_name,
          features: features
        }
        printer.print params
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
