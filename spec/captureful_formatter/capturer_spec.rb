require 'spec_helper'
require 'fileutils'
require 'pathname'

describe CapturefulFormatter::Capturer do
  let(:output_directory) { Dir.tmpdir + "/spec" }

  let(:step_struct) do
    instance_double(
      "CapturefulFormatter::Structures::Step",
      scenario: instance_double("CapturefulFormatter::Structures::Scenario", hash: "hash", step_count: 1)
    )
  end

  before do
    @orig_directory = CapturefulFormatter.configuration.output_directory
    CapturefulFormatter.configure do |c|
      c.output_directory = output_directory
    end
  end

  after do
    FileUtils.remove_entry_secure(output_directory) if Dir.exist? output_directory
    CapturefulFormatter.configure do |c|
      c.output_directory = @orig_directory
    end
  end

  describe '.init' do
    subject { CapturefulFormatter::Capturer.init }
    specify { expect{ subject }.to change{ Dir.exist? output_directory } }
  end

  describe '.capture' do
    before { CapturefulFormatter::Capturer.init }
    it do
      capybara_session = double("current_session")
      allow(Capybara).to receive(:current_session).and_return(capybara_session)
      expect(capybara_session).to receive(:save_screenshot)
      expect(capybara_session).to receive(:save_page)
      CapturefulFormatter::Capturer.capture step_struct
    end
  end
end
