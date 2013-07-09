require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

desc "Build the current version of type-enforcer"
task :build do
  `gem build type-enforcer.gemspec`
end

task :default => :spec