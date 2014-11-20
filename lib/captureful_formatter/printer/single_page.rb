module CapturefulFormatter
  module Printer
    class SinglePage < Base

      def print params
        template = Template.new(params)
        filename = File.join(CapturefulFormatter.configuration.output_directory, "/index.html")
        File.write(filename ,template.render(File.read(template_path)))
      end

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
    end
  end
end
