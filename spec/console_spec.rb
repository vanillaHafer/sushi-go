require "spec_helper"
require "tempfile"

RSpec.describe Console do
  def capture_log
    Tempfile.create("out") do |tmp|
      og = $stdout
      $stdout = tmp
      yield if block_given?
      $stdout = og
      tmp.rewind
      tmp.read
    end
  end

  describe ".clear_screen" do
    it "writes 50 newlines" do
      log = capture_log { described_class.clear_screen }
      expect(log).to eq("\n" * 50)
    end
  end
end
