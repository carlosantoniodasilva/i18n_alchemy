# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "i18n-alchemy/version"

Gem::Specification.new do |s|
  s.name        = "i18n-alchemy"
  s.version     = I18n::Alchemy::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Carlos Antonio da Silva"]
  s.email       = ["carlosantoniodasilva@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "i18n-alchemy"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "activerecord", "~> 3.0.3"
  s.add_dependency "i18n", "~> 0.5.0"
end
