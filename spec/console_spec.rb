require "spec_helper"

RSpec.describe Console do
  def capture_log
    og = $stdout
    Tempfile.create("out") do |tmp|
      $stdout = tmp
      yield if block_given?
      tmp.rewind
      tmp.read
    end
  ensure
    $stdout = og
  end

  describe ".clear_screen" do
    let(:log) { capture_log { described_class.clear_screen } }

    it "writes 50 newlines" do
      expect(log).to eq("\n" * 50)
    end
  end

  describe ".end_of_game_recap" do
    let(:players) do
      2.times.map { Player.new.tap { |p| p.maki_rolls = [0, 0, 0] } }
    end
    let(:log) do
      capture_log { described_class.end_of_game_recap(players) }
    end

    it "says thank you" do
      expect(log.uncolorize).to eq(("\n" * 50) + <<~OUT)
        **********************
        * THANKS FOR PLAYING *
        **********************

        *****************
        * Player Plates *
        *****************
        
        ************   ************   
        *   (0)    *   *   (0)    *   
        * Player 1 *   * Player 2 *   
        ************   ************   
        Score: 0       Score: 0       

        Score: 0       Score: 0       

        Score: 0       Score: 0       


        Score: 0       Score: 0       

      OUT
    end
  end
end
