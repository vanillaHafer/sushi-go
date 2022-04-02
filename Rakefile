begin
  require "standard/rake"
  require "rspec/core/rake_task"
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end

desc "Run standardrv --fix"
task fix: :'standard:fix' do
  puts "✨ Fixed!"
end

task default: :spec
