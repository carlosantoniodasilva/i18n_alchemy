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

class MiniTest::Unit::TestCase
  # AR 3.0 does not have assign_attributes and without_protection option, so we
  # are going to skip such tests in this version.
  def support_assign_attributes_without_protection?
    @support_assign_attributes ||= ActiveRecord::VERSION::STRING >= "3.1.0"
  end
end
