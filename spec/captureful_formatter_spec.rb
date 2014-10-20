require 'spec_helper'
require 'securerandom'

describe CapturefulFormatter do
  describe "VERSION" do
    subject { CapturefulFormatter::VERSION }
    it { is_expected.to eq "0.0.1" }
  end

  describe ".configuration" do
    subject { CapturefulFormatter.configuration }
    it { is_expected.to have_attributes(:output_directory => "./.captureful_formatter")}
    it { is_expected.to have_attributes(:target_type => [:feature])}
    it { is_expected.to have_attributes(:template_path => a_string_starting_with("/"))}
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
