# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "fake_plastic_tree/version"

Gem::Specification.new do |s|
  s.name        = "fake_plastic_tree"
  s.version     = FakePlasticTree::VERSION
  s.authors     = ["Brian Leonard"]
  s.email       = ["brian@bleonard.com"]
  s.homepage    = ""
  s.summary     = %q{Mocks common methods used when interacting with the Braintree payment gateway.}
  s.description = %q{Mocks common methods used when interacting with the Braintree payment gateway.}

  s.rubyforge_project = "fake_plastic_tree"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_development_dependency('rspec', '~> 2.4')
  s.add_dependency('braintree', '~> 2.10.0')
end
