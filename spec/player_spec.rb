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

  describe "#plate_value" do
    let(:plate) { [[]] }
    let(:player) { Player.new.tap { |p| p.plate = plate } }
    let(:points) { player.plate_value(0) }

    context "with 1 tempura" do
      let(:plate) do
        [[Card.new(card_name: "Tempura")]]
      end

      it "has no points" do
        expect(points).to eq(0)
      end
    end

    context "Wasabi" do
      context "when wasabi is present, but no nigiri" do
        let(:plate) do
          [[Card.new(card_name: "Wasabi")]]
        end

        it "has no points" do
          expect(points).to eq(0)
        end
      end

      context "when wasabi is present, but played after nigiri" do
        let(:plate) do
          [[
            Card.new(card_name: "Nigiri", value: 5),
            Card.new(card_name: "Wasabi")
          ]]
        end

        it "has the points of the nigiri" do
          expect(points).to eq(5)
        end
      end

      context "when wasabi is present, and played before nigiri" do
        let(:plate) do
          [[
            Card.new(card_name: "Wasabi"),
            Card.new(card_name: "Nigiri", value: 5)
          ]]
        end

        it "multiplies the card value by 3" do
          expect(points).to eq(15)
        end
      end
    end

    context "with 2 tempura" do
      let(:plate) do
        [2.times.map { Card.new(card_name: "Tempura") }]
      end

      it "has no points" do
        expect(points).to eq(5)
      end
    end

    context "with 2 sashimi" do
      let(:plate) do
        [2.times.map { Card.new(card_name: "Sashimi") }]
      end

      it "has no points" do
        expect(points).to eq(0)
      end
    end

    context "with 3 shashimi" do
      let(:plate) do
        [3.times.map { Card.new(card_name: "Sashimi") }]
      end

      it "has no points" do
        expect(points).to eq(10)
      end
    end

    context "dumplings" do
      context "dumpling limit" do
        let(:plate) do
          [10.times.map { Card.new(card_name: "Dumpling") }]
        end

        it "caps the points at 5" do
          expect(points).to eq(15)
        end
      end

      described_class::DUMPLING_CHART.each do |k, v|
        context "scoring" do
          let(:plate) do
            [k.times.map { Card.new(card_name: "Dumpling") }]
          end

          it "awards #{v} points for #{k} cards" do
            expect(points).to eq(v)
          end
        end
      end
    end
  end

  describe "#total_value_of_all_plates" do
    let(:plate) do
      [
        [Card.new(card_name: "Nigiri", value: 6)],
        [Card.new(card_name: "Nigiri", value: 6)],
        [Card.new(card_name: "Nigiri", value: 6)]
      ]
    end
    let(:player) { Player.new.tap { |p| p.plate = plate } }

    it "sums the plate sizes" do
      expect(player.total_value_of_all_plates).to eq(18)
    end
  end
end
