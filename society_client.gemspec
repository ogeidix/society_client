# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "society_client/version"

Gem::Specification.new do |s|
  s.name        = "society_client"
  s.version     = SocietyClient::VERSION
  s.authors     = ["ogeidix"]
  s.email       = ["diegogiorgini@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "society_client"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"
  s.add_development_dependency "webmock"
  s.add_development_dependency "vcr"
  s.add_runtime_dependency "httparty"
end