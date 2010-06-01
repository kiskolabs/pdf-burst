require "bundler"
Bundler.setup

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)

gemspec = eval(File.read("pdf-burst.gemspec"))

task :build => "#{gemspec.full_name}.gem"

file "#{gemspec.full_name}.gem" => gemspec.files + ["pdf-burst.gemspec"] do
  system "gem build pdf-burst.gemspec"
  system "gem install pdf-burst-#{PDF::Burst::VERSION}.gem"
end
