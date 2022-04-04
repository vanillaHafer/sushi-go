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

  describe ".update_players" do
    let(:player_1) do
      Player.new
    end
    let(:player_2) do
      Player.new
    end
    let(:players) { [player_1, player_2] }
    let(:round) { 1 }

    it "adds the maki rolls for the round" do
      player_1.plate[round - 1] = [
        Card.new(card_name: "Maki", maki_value: 1),
        Card.new(card_name: "Maki", maki_value: 2)
      ]

      expect {
        Player.update_players(players, round)
      }.to change {
        player_1.maki_rolls[round - 1]
      }.from(nil)
        .to(3)
    end

    it "adds the pudding for the round" do
      player_1.plate[round - 1] = [
        Card.new(card_name: "Pudding"),
        Card.new(card_name: "Maki"),
        Card.new(card_name: "Pudding")
      ]

      expect {
        Player.update_players(players, round)
      }.to change {
        player_1.puddings
      }.from(0)
        .to(2)
    end
  end

  describe "#current_hand" do
    let(:player) do
      Player.new.tap do |player|
        player.hand = [
          Card.new(card_name: "Pudding"),
          Card.new(card_name: "Wasabi"),
          Card.new(card_name: "Squid Nigiri"),
          Card.new(card_name: "Maki", maki_value: 3)
        ]
      end
    end

    it "returns the card names" do
      expect(player.current_hand).to eq([
        "Pudding",
        "Wasabi",
        "Squid Nigiri",
        "Maki (***)"
      ])
    end
  end

  describe ".rotate_hands" do
    let(:player_1) do
      create(:player, hand: [
        Card.new(card_name: "Pudding"),
        Card.new(card_name: "Wasabi")
      ])
    end

    let(:player_2) do
      create(:player, hand: [
        Card.new(card_name: "Squid Nigiri"),
        Card.new(card_name: "Maki", maki_value: 3)
      ])
    end

    let(:player_3) do
      create(:player, hand: [
        Card.new(card_name: "Maki", maki_value: 1),
        Card.new(card_name: "Pudding")
      ])
    end

    let(:player_4) do
      create(:player, hand: [
        Card.new(card_name: "Chopsticks"),
        Card.new(card_name: "Wasabi")
      ])
    end
    let(:players) {
      [
        player_1,
        player_2,
        player_3,
        player_4
      ]
    }

    def rotate
      Player.rotate_hands(players, clockwise)
    end

    context "when counter-clockwise" do
      let(:clockwise) { false }

      it "gives player 1 hand to player 2" do
        p2_hand = player_2.hand

        expect { rotate }.to change { player_1.hand }.to(p2_hand)
      end

      it "gives player 2 hand to player 3" do
        p3_hand = player_3.hand
        expect { rotate }.to change { player_2.hand }.to(p3_hand)
      end

      it "gives player 3 hand to player 4" do
        p4_hand = player_4.hand
        expect { rotate }.to change { player_3.hand }.to(p4_hand)
      end

      it "gives player 4 hand to player 1" do
        p1_hand = player_1.hand
        expect { rotate }.to change { player_4.hand }.to(p1_hand)
      end
    end

    context "when clockwise" do
      let(:clockwise) { true }

      it "gives player 1 hand to player 4" do
        p4_hand = player_4.hand

        expect { rotate }.to change { player_1.hand }.to(p4_hand)
      end

      it "gives player 2 hand to player 1" do
        p1_hand = player_1.hand
        expect { rotate }.to change { player_2.hand }.to(p1_hand)
      end

      it "gives player 3 hand to player 2" do
        p2_hand = player_2.hand
        expect { rotate }.to change { player_3.hand }.to(p2_hand)
      end

      it "gives player 4 hand to player 3" do
        p3_hand = player_3.hand
        expect { rotate }.to change { player_4.hand }.to(p3_hand)
      end
    end
  end

  describe "#update_pudding_score" do
    context "when there is one first place winner" do
      let(:players) do
        [
          create(:player, :pudding, puddings: 4),
          create(:player, :pudding, puddings: 3),
          create(:player, :pudding, puddings: 2),
          create(:player, :pudding, puddings: 2),
          create(:player, :pudding, puddings: 1)
        ]
      end

      it "awards 6 points" do
        expect {
          Player.update_pudding_score(players)
        }.to change {
          players.first.pudding_score
        }.from(0)
          .to(6)
      end

      it "remove 6 points from last" do
        expect {
          Player.update_pudding_score(players)
        }.to change {
          players.last.pudding_score
        }.from(0)
          .to(-6)
      end
    end

    context "when there is two-way tie for first place" do
      let(:players) do
        [
          create(:player, :pudding, puddings: 4),
          create(:player, :pudding, puddings: 4),
          create(:player, :pudding, puddings: 3),
          create(:player, :pudding, puddings: 3),
          create(:player, :pudding, puddings: 1)
        ]
      end

      it "gives each first placer 3 points" do
        expect {
          Player.update_pudding_score(players)
        }.to change {
          [
            players[0].pudding_score,
            players[1].pudding_score
          ]
        }.from([0, 0])
          .to([3, 3])
      end

      it "remove 6 points from last" do
        expect {
          Player.update_pudding_score(players)
        }.to change {
          players.last.pudding_score
        }.from(0)
          .to(-6)
      end
    end

    context "when there is three-way tie for first place" do
      let(:players) do
        [
          create(:player, :pudding, puddings: 4),
          create(:player, :pudding, puddings: 4),
          create(:player, :pudding, puddings: 4),
          create(:player, :pudding, puddings: 3),
          create(:player, :pudding, puddings: 1)
        ]
      end

      it "gives each first placer 2 points" do
        expect {
          Player.update_pudding_score(players)
        }.to change {
          [
            players[0].pudding_score,
            players[1].pudding_score,
            players[2].pudding_score
          ]
        }.from([0, 0, 0])
          .to([2, 2, 2])
      end

      it "remove 6 points from last" do
        expect {
          Player.update_pudding_score(players)
        }.to change {
          players.last.pudding_score
        }.from(0)
          .to(-6)
      end
    end

    context "when there is a four-way tie for first place" do
      let(:players) do
        [
          create(:player, :pudding, puddings: 4),
          create(:player, :pudding, puddings: 4),
          create(:player, :pudding, puddings: 4),
          create(:player, :pudding, puddings: 4),
          create(:player, :pudding, puddings: 1)
        ]
      end

      it "gives each first placer 1 point" do
        expect {
          Player.update_pudding_score(players)
        }.to change {
          [
            players[0].pudding_score,
            players[1].pudding_score,
            players[2].pudding_score,
            players[3].pudding_score
          ]
        }.from([0, 0, 0, 0])
          .to([1, 1, 1, 1])
      end

      it "remove 6 points from last" do
        expect {
          Player.update_pudding_score(players)
        }.to change {
          players.last.pudding_score
        }.from(0)
          .to(-6)
      end
    end

    context "when there is a five-way tie for first place" do
      let(:players) do
        [
          create(:player, :pudding, puddings: 4),
          create(:player, :pudding, puddings: 4),
          create(:player, :pudding, puddings: 4),
          create(:player, :pudding, puddings: 4),
          create(:player, :pudding, puddings: 4)
        ]
      end

      it "no puddings are awarded" do
        expect {
          Player.update_pudding_score(players)
        }.to_not change {
          [
            players[0].pudding_score,
            players[1].pudding_score,
            players[2].pudding_score,
            players[3].pudding_score,
            players[4].pudding_score
          ]
        }
      end
    end

    context "when there are only 2 players" do
      context "and one first place winner" do
        let(:players) do
          [
            create(:player, :pudding, puddings: 4),
            create(:player, :pudding, puddings: 3)
          ]
        end
        it "awards 6 points to first place" do
          expect {
            Player.update_pudding_score(players)
          }.to change {
            players.first.pudding_score
          }.from(0)
          .to(6)
        end
        
        it "not remove any points from the other player" do
          expect {
            Player.update_pudding_score(players)
          }.to_not change {
            players.last.pudding_score
          }
        end
      end

      context "and there is a tie for first place" do
        let(:players) do
          [
            create(:player, :pudding, puddings: 3),
            create(:player, :pudding, puddings: 3)
          ]
        end

        it "no points are awarded" do
          expect {
            Player.update_pudding_score(players)
          }.to_not change {
            [
              players[0].pudding_score,
              players[1].pudding_score
            ]
          }
        end
      end
    end

    context "when there is one last place winner" do
      let(:players) do
        [
          create(:player, :pudding, puddings: 4),
          create(:player, :pudding, puddings: 3),
          create(:player, :pudding, puddings: 2),
          create(:player, :pudding, puddings: 2),
          create(:player, :pudding, puddings: 1)
        ]
      end

      it "awards 6 points" do
        expect {
          Player.update_pudding_score(players)
        }.to change {
          players.first.pudding_score
        }.from(0)
          .to(6)
      end

      it "remove 6 points from last" do
        expect {
          Player.update_pudding_score(players)
        }.to change {
          players.last.pudding_score
        }.from(0)
          .to(-6)
      end
    end

    context "when there is two-way tie for last place" do
      let(:players) do
        [
          create(:player, :pudding, puddings: 4),
          create(:player, :pudding, puddings: 3),
          create(:player, :pudding, puddings: 2),
          create(:player, :pudding, puddings: 1),
          create(:player, :pudding, puddings: 1)
        ]
      end

      it "gives first place 6 points" do
        expect {
          Player.update_pudding_score(players)
        }.to change {
          players[0].pudding_score
        }.from(0)
          .to(6)
      end

      it "remove 3 points from last placers" do
        expect {
          Player.update_pudding_score(players)
        }.to change {
          [
            players[3].pudding_score,
            players[4].pudding_score,
          ]
        }.from([0,0])
          .to([-3,-3])
      end
    end

    context "when there is three-way tie for last place" do
      let(:players) do
        [
          create(:player, :pudding, puddings: 4),
          create(:player, :pudding, puddings: 3),
          create(:player, :pudding, puddings: 1),
          create(:player, :pudding, puddings: 1),
          create(:player, :pudding, puddings: 1)
        ]
      end

      it "gives first place 6 points" do
        expect {
          Player.update_pudding_score(players)
        }.to change {
          players[0].pudding_score
        }.from(0)
          .to(6)
      end

      it "remove 2 points from the last placers" do
        expect {
          Player.update_pudding_score(players)
        }.to change {
          [
            players[2].pudding_score,
            players[3].pudding_score,
            players[4].pudding_score,
          ]
        }.from([0,0,0])
          .to([-2,-2,-2])
      end
    end

    context "when there is a four-way tie for last place" do
      let(:players) do
        [
          create(:player, :pudding, puddings: 4),
          create(:player, :pudding, puddings: 1),
          create(:player, :pudding, puddings: 1),
          create(:player, :pudding, puddings: 1),
          create(:player, :pudding, puddings: 1)
        ]
      end

      it "gives first place 6 points" do
        expect {
          Player.update_pudding_score(players)
        }.to change {
          players[0].pudding_score
        }.from(0)
          .to(6)
      end

      it "remove 1 points from last placers" do
        expect {
          Player.update_pudding_score(players)
        }.to change {
          [
            players[1].pudding_score,
            players[2].pudding_score,
            players[3].pudding_score,
            players[4].pudding_score,
          ]
        }.from([0,0,0,0])
          .to([-1,-1,-1,-1])
      end
    end

    context "when all players have the same amount of pudding" do
      context "in a two player game" do
        let(:players) do
          [
            create(:player, :pudding, puddings: 1),
            create(:player, :pudding, puddings: 1)
          ]
        end

        it "awards no points to anyone" do
          expect{
            Player.update_pudding_score(players) 
          }.to_not change {
            [
              players[0].pudding_score,
              players[1].pudding_score
            ]
          }
        end
      end

      context "in a three player game" do
        let(:players) do
          [
            create(:player, :pudding, puddings: 1),
            create(:player, :pudding, puddings: 1),
            create(:player, :pudding, puddings: 1)
          ]
        end

        it "awards no points to anyone" do
          expect {
            Player.update_pudding_score(players)
          }.to_not change {
            [
              players[0],
              players[1],
              players[2]
            ]
          }
        end
        
      end

      context "in a four player game" do
        let(:players) do
          [
            create(:player, :pudding, puddings: 1),
            create(:player, :pudding, puddings: 1),
            create(:player, :pudding, puddings: 1),
            create(:player, :pudding, puddings: 1)
          ]
        end

        it "awards no points to anyone" do
          expect {
            Player.update_pudding_score(players)
          }.to_not change {
            [
              players[0].pudding_score,
              players[1].pudding_score,
              players[2].pudding_score,
              players[3].pudding_score,
            ]
          }
        end
      end

      context "in a five player game" do
        let(:players) do
          [
            create(:player, :pudding, puddings: 1),
            create(:player, :pudding, puddings: 1),
            create(:player, :pudding, puddings: 1),
            create(:player, :pudding, puddings: 1),
            create(:player, :pudding, puddings: 1)
          ]
        end

        it "awards no points to anyone" do
          expect {
            Player.update_pudding_score(players)
          }.to_not change {
            [
              players[0].pudding_score,
              players[1].pudding_score,
              players[2].pudding_score,
              players[3].pudding_score,
              players[4].pudding_score,
            ]
          }
        end
      end
    end

    context "when multiple players tie for first and multiple players tie for last" do
      context "in a 4 player game" do
        let(:players) do
          [
            create(:player, :pudding, puddings: 4),
            create(:player, :pudding, puddings: 4),
            create(:player, :pudding, puddings: 1),
            create(:player, :pudding, puddings: 1)
          ]
        end

        it "awards 3 points to the first placers" do
          expect {
            Player.update_pudding_score(players)
          }.to change {
            [
              players[0].pudding_score,
              players[1].pudding_score
            ]
          }.from([0,0])
          .to([3,3])
        end

        it "removes 3 points from the last placers" do
          expect {
            Player.update_pudding_score(players)
          }.to change {
            [
              players[2].pudding_score,
              players[3].pudding_score
            ]
          }.from([0,0])
          .to([-3,-3])
        end
      end

      context "in a 5 player game" do

        context "with 2 winners and 2 losers" do
          let(:players) do
            [
              create(:player, :pudding, puddings: 4),
              create(:player, :pudding, puddings: 4),
              create(:player, :pudding, puddings: 1),
              create(:player, :pudding, puddings: 0),
              create(:player, :pudding, puddings: 0)
            ]
          end

          it "adds 3 points to the winners" do
            expect {
              Player.update_pudding_score(players)
            }.to change {
              [
                players[0].pudding_score,
                players[1].pudding_score
              ]
            }.from([0,0])
            .to([3,3])
          end

          it "does not change the middle players pudding score" do
            expect {
              Player.update_pudding_score(players)
            }.to_not change {
              players[2].pudding_score
            }
          end

          it "removes 3 points from the losers" do
            expect {
              Player.update_pudding_score(players)
            }.to change {
              [
                players[3].pudding_score,
                players[4].pudding_score
              ]
            }.from([0,0])
            .to([-3,-3])
          end
        end

        context "with 3 winners and 2 losers" do
          let(:players) do
            [
              create(:player, :pudding, puddings: 4),
              create(:player, :pudding, puddings: 4),
              create(:player, :pudding, puddings: 4),
              create(:player, :pudding, puddings: 0),
              create(:player, :pudding, puddings: 0)
            ]
          end

          it "adds 2 points to the winners" do
            expect {
              Player.update_pudding_score(players)
            }.to change {
              [
                players[0].pudding_score,
                players[1].pudding_score,
                players[2].pudding_score
              ]
            }.from([0,0,0])
            .to([2,2,2])
          end

          it "removes 3 points from the losers" do
            expect {
              Player.update_pudding_score(players)
            }.to change {
              [
                players[3].pudding_score,
                players[4].pudding_score
              ]
            }.from([0,0])
            .to([-3,-3])
          end
        end

        context "with 2 winners and 3 losers" do
          let(:players) do
            [
              create(:player, :pudding, puddings: 4),
              create(:player, :pudding, puddings: 4),
              create(:player, :pudding, puddings: 0),
              create(:player, :pudding, puddings: 0),
              create(:player, :pudding, puddings: 0)
            ]
          end

          it "adds 3 points to the winners" do
            expect {
              Player.update_pudding_score(players)
            }.to change {
              [
                players[0].pudding_score,
                players[1].pudding_score
              ]
            }.from([0,0])
            .to([3,3])
          end

          it "removes 2 points from the losers" do
            expect {
              Player.update_pudding_score(players)
            }.to change {
              [
                players[2].pudding_score,
                players[3].pudding_score,
                players[4].pudding_score
              ]
            }.from([0,0,0])
            .to([-2,-2,-2])
          end
        end
      end
    end
  end

  describe "#update_maki_points" do
    context "when there is one first place winner" do
      let(:players) do
        [
          create(:player, :maki_3),
          create(:player, :maki_1),
          create(:player, :maki_1),
          create(:player, :maki_2)
        ]
      end

      it "awards 6 points" do
        expect {
          Player.update_maki_points(players)
        }.to change {
          players.first.maki_points[0]
        }.from(nil)
          .to(6)
      end

      it "awards 3 points to second" do
        expect {
          Player.update_maki_points(players)
        }.to change {
          players.last.maki_points[0]
        }.from(nil)
          .to(3)
      end
    end

    context "when there is two-way tie for second place" do
      let(:players) do
        [
          create(:player, :maki_3),
          create(:player, :maki_1),
          create(:player, :maki_2),
          create(:player, :maki_2)
        ]
      end

      it "gives each second place 1 point" do
        expect {
          Player.update_maki_points(players)
        }.to change {
          [
            players[2].maki_points[0],
            players[3].maki_points[0]
          ]
        }.from([nil, nil])
          .to([1, 1])
      end
    end

    context "when there is three-way tie for second place" do
      let(:players) do
        [
          create(:player, :maki_3),
          create(:player, :maki_2),
          create(:player, :maki_2),
          create(:player, :maki_2)
        ]
      end

      it "gives each second place 1 point" do
        expect {
          Player.update_maki_points(players)
        }.to change {
          [
            players[1].maki_points[0],
            players[2].maki_points[0],
            players[3].maki_points[0]
          ]
        }.from([nil, nil, nil])
          .to([1, 1, 1])
      end
    end

    context "when there is a four-way tie for second place" do
      let(:players) do
        [
          create(:player, :maki_3),
          create(:player, :maki_2),
          create(:player, :maki_2),
          create(:player, :maki_2),
          create(:player, :maki_2)
        ]
      end

      it "gives each second place 0 points" do
        expect {
          Player.update_maki_points(players)
        }.to change {
          [
            players[1].maki_points[0],
            players[2].maki_points[0],
            players[3].maki_points[0],
            players[4].maki_points[0]
          ]
        }.from([nil, nil, nil, nil])
          .to([0, 0, 0, 0])
      end
    end

    context "when there are two first place winners" do
      let(:players) do
        [
          create(:player, :maki_3),
          create(:player, :maki_3),
          create(:player, :maki_2),
          create(:player, :maki_2)
        ]
      end

      it "awards 3 points to each one" do
        expect {
          Player.update_maki_points(players)
        }.to change {
          [
            players[0].maki_points[0],
            players[1].maki_points[0]
          ]
        }.from([nil, nil])
          .to([3, 3])
      end

      it "does not award second place" do
        expect {
          Player.update_maki_points(players)
        }.not_to change {
          [
            players[2].maki_points[0],
            players[3].maki_points[0]
          ]
        }.from([nil, nil])
      end
    end

    context "when there are three first place winners" do
      let(:players) do
        [
          create(:player, :maki_3),
          create(:player, :maki_3),
          create(:player, :maki_3),
          create(:player, :maki_2)
        ]
      end

      it "awards 2 points to each one" do
        expect {
          Player.update_maki_points(players)
        }.to change {
          [
            players[0].maki_points[0],
            players[1].maki_points[0],
            players[2].maki_points[0]
          ]
        }.from([nil, nil, nil])
          .to([2, 2, 2])
      end

      it "does not award second place" do
        expect {
          Player.update_maki_points(players)
        }.not_to change {
          [
            players[3].maki_points[0]
          ]
        }.from([nil])
      end
    end

    context "when there are four first place winners" do
      let(:players) do
        [
          create(:player, :maki_3),
          create(:player, :maki_3),
          create(:player, :maki_3),
          create(:player, :maki_3),
          create(:player, :maki_1)
        ]
      end

      it "awards 1 point to each one" do
        expect {
          Player.update_maki_points(players)
        }.to change {
          players.map { |pl| pl.maki_points[0] }
        }.from([nil, nil, nil, nil, nil])
          .to([1, 1, 1, 1, nil])
      end

      it "does not award second place" do
        expect {
          Player.update_maki_points(players)
        }.not_to change {
          [
            players[4].maki_points[0]
          ]
        }.from([nil])
      end
    end

    context "when there are five first place winners" do
      let(:players) do
        [
          create(:player, :maki_3),
          create(:player, :maki_3),
          create(:player, :maki_3),
          create(:player, :maki_3),
          create(:player, :maki_3),
          create(:player, :maki_1)
        ]
      end

      it "awards 1 point to each one" do
        expect {
          Player.update_maki_points(players)
        }.to change {
          players.map { |pl| pl.maki_points[0] }
        }.from([nil, nil, nil, nil, nil, nil])
          .to([1, 1, 1, 1, 1, nil])
      end

      it "does not award second place" do
        expect {
          Player.update_maki_points(players)
        }.not_to change {
          [
            players[5].maki_points[0]
          ]
        }.from([nil])
      end
    end
  end
end
