# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "tune_me_up/version"

Gem::Specification.new do |s|
  s.name        = "tune_me_up"
  s.version     = TuneMeUp::VERSION
  s.authors     = ["Federico M. Iachetti"]
  s.email       = ["iachetti.federico@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Tune up (style) an instance of a class}
  s.description = %q{This gem allows you to give some functionality to an instance of a class without altering the oter instances, basing itself on some given criteria.}

  s.rubyforge_project = "tune_me_up"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
