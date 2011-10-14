require 'bundler'

Bundler::GemHelper.install_tasks

require 'rdoc/task'
require 'rspec/core/rake_task'

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

# extracted from https://github.com/grosser/project_template
rule /^version:bump:.*/ do |t|
  sh "git status | grep 'nothing to commit'" # ensure we are not dirty
  index = ['major', 'minor','patch'].index(t.name.split(':').last)
  file = 'lib/hash_blue/version.rb'

  version_file = File.read(file)
  old_version, *version_parts = version_file.match(/(\d+)\.(\d+)\.(\d+)/).to_a
  version_parts[index] = version_parts[index].to_i + 1
  new_version = version_parts * '.'
  File.open(file,'w'){|f| f.write(version_file.sub(old_version, new_version)) }

  sh "bundle && git add -f #{file} Gemfile.lock && git commit -m 'bump version to #{new_version}'"
end

