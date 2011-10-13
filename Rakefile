begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rdoc/task'

require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

task :default => :test

RSpec::Core::RakeTask.new(:test) do |spec|
  spec.skip_bundler = true
  spec.warning = true
  spec.pattern = 'spec/*_spec.rb'
  spec.rspec_opts = '--color --format doc'
end

Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Hash-Blue'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.md')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

