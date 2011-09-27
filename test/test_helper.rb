require "rubygems"
require "bundler/setup"
Bundler.require :test

require "minitest/unit"
MiniTest::Unit.autorun

require "i18n_alchemy"
I18n.default_locale = :en
I18n.locale = :en
I18n.load_path << Dir[File.expand_path("../locale/*.yml", __FILE__)]

require "db/test_schema"
Dir["test/models/*.rb"].each { |file| require File.expand_path(file) }
