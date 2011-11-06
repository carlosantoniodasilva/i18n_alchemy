require "rubygems"
require "bundler/setup"
Bundler.require :test

require "minitest/unit"
MiniTest::Unit.autorun

require "i18n_alchemy"
require "action_view"

# Setup I18n after other requires to make sure our locales will override any
# ActiveSupport / ActionView defaults.
I18n.default_locale = :en
I18n.locale = :en
I18n.load_path << Dir[File.expand_path("../locale/*.yml", __FILE__)]

require "db/test_schema"
Dir["test/models/*.rb"].each { |file| require File.expand_path(file) }
