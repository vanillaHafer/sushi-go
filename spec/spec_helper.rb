require "simplecov"

SimpleCov.start do
  enable_coverage :branch

  %w[console.rb].each do |skip|
    add_filter skip
  end
end

require "tempfile"
require "colorize"
require "factory_bot"

require "./card"
require "./deck"
require "./player"
require "./console"

RSpec.configure do |config|
  config.include(FactoryBot::Syntax::Methods)
  config.before(:suite) do
    FactoryBot.find_definitions
  end
end
