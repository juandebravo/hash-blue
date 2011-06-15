# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "hash_blue/version"

Gem::Specification.new do |s|
  s.name        = "hash-blue"
  s.version     = HashBlue::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Juan de Bravo"]
  s.email       = ["juandebravo@gmail.com"]
  s.homepage    = "https://api.hashblue.com/doc/"
  s.summary     = %q{This gem provides a smooth access to _#_blue API.}
  s.description = %q{O2 Labs has exposed the power of #blue to developers via a 
    simple REST & JSON based API, combined with oAuth2 to developers who can 
    create  new ways for users to manage their texts and add combine the ubiquity 
    of SMS with their applications, users simply grant an application access to 
    their messages stream or just certain messages.}

  s.rubyforge_project = "hash-blue"

  s.files         = `git ls-files`.split("\n")
  s.files.delete(".gitignore")
  s.files.delete(".rspec")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency("json_pure" , ">= 1.4.3")
  
end
