FactoryBot.define do
  to_create { nil }

  factory :player do
    [1, 2, 3].each do |i|
      trait :"maki_#{i}" do
        maki_rolls { [i, 0, 0] }
      end
      trait :pudding do
        puddings = 0
      end
    end
  end
end
