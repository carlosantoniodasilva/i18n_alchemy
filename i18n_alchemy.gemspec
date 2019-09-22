# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "i18n_alchemy/version"

Gem::Specification.new do |s|
  s.name        = "i18n_alchemy"
  s.version     = I18n::Alchemy::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Carlos Antonio da Silva"]
  s.email       = ["carlosantoniodasilva@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{I18n date/number parsing/localization}
  s.description = %q{I18n date/number parsing/localization}

  s.rubyforge_project = "i18n_alchemy"

  s.files         = Dir["CHANGELOG.md", "MIT-LICENSE", "README.md", "lib/**/*"]
  s.test_files    = Dir["test/**/*"]
  s.require_paths = ["lib"]

  s.add_dependency "activesupport", ">= 4.0.0", "< 6.1"
  s.add_dependency "i18n", ">= 0.7"

  s.add_development_dependency "actionpack", ">= 4.0.0", "< 6.1"
  s.add_development_dependency "activerecord", ">= 4.0.0", "< 6.1"
  s.add_development_dependency "minitest", ">= 4.3.2"
  s.add_development_dependency "rake", ">= 10.1"
end
