require "spec_helper"

RSpec.describe Player do
  describe "#new" do
    context "default values" do
      let(:player) { Player.new }

      it "has 3 plates" do
        expect(player.plate).to eq([[], [], []])
      end

      it "has an empty hand" do
        expect(player.hand).to eq([])
      end

      it "has 0 puddings" do
        expect(player.puddings).to eq(0)
      end

      it "has a 0 pudding score" do
        expect(player.pudding_score).to eq(0)
      end

      it "has a empty maki_points" do
        expect(player.maki_points).to eq([])
      end

      it "has a empty maki_rolls" do
        expect(player.maki_rolls).to eq([])
      end
    end
  end
end
