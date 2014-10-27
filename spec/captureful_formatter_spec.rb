require 'spec_helper'
require 'securerandom'

describe CapturefulFormatter do
  describe "VERSION" do
    subject { CapturefulFormatter::VERSION }
    it { is_expected.to eq "0.0.2" }
  end

  describe ".configuration" do
    subject { CapturefulFormatter.configuration }
    specify { expect(subject.output_directory).to eq "./.captureful_formatter" }
    specify { expect(subject.target_type).to eq [:feature] }
    specify { expect(subject.template_path).to match(/^\//) }
  end

  describe ".configure" do
    let(:configuration) { CapturefulFormatter.configuration }
    let(:new_attribute) { SecureRandom.base64(10) }
    subject do
      lambda do
        CapturefulFormatter.configure do |c|
          c.output_directory = new_attribute
        end
      end
    end
    it { is_expected.to change { configuration.output_directory }.to(new_attribute) }
  end
end
