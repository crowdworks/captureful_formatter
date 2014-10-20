require 'spec_helper'

describe CapturefulFormatter::Printer do
  shared_examples "a safety file path" do
    it "is existed" do
      expect(File.exists? subject).to be_truthy
    end

    it "is full path" do
      expect(subject).to start_with("/")
    end
  end

  describe "#template_file" do
    subject { CapturefulFormatter::Printer.template_path }

    it "returns default template" do
      expect(subject).to eq File.absolute_path(File.dirname(__FILE__) + "../../../templates/test_report.html.erb")
    end

    describe "on seted up template path at configure" do
      before do
        CapturefulFormatter.configure do |config|
          config.template_path = template
        end
      end

      context "setup a absolute path" do
        let(:template) { File.dirname(__FILE__) + "/../example/test_template.erb.html" }
        it_behaves_like "a safety file path"
      end

      context "setup a relative path" do
        let(:template) { "./spec/example/test_template.erb.html" }
        it_behaves_like "a safety file path"
      end

      context "setup no exists file" do
        let(:template) { "/path/to/missing" }
        specify { expect{ subject }.to raise_error(CapturefulFormatter::Printer::TemplateMissingError) }
      end
    end
  end
end
