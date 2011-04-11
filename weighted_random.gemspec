# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "weighted_random/version"

Gem::Specification.new do |s|
  s.name        = "weighted_random"
  s.version     = WeightedRandom::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Szymon Przybył"]
  s.email       = ["apocalyptiq@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Weighted randomization extension for ActiveRecord}
  s.description = %q{ActiveRecord extension for weighted randomization which supplies loading records with weight for randomize into database and weighted randomization of them}

  s.rubyforge_project = "weighted_random"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
