require "rubygems"
require "bundler/setup"
Bundler.require :test

require "minitest/unit"
MiniTest::Unit.autorun

require "i18n_alchemy"
require "action_view"
require "active_record"

# Setup I18n after other requires to make sure our locales will override any
# ActiveSupport / ActionView defaults.
I18n.default_locale = :en
I18n.locale = :en
I18n.load_path << Dir[File.expand_path("../locale/*.yml", __FILE__)]

require "db/test_schema"
Dir["test/custom_parsers/*.rb"].each { |file| require File.expand_path(file) }
Dir["test/models/*.rb"].each { |file| require File.expand_path(file) }

module I18n::Alchemy
  class TestCase < MiniTest::Unit::TestCase
    # AR 3.0 does not have assign_attributes and without_protection option, so we
    # are going to skip such tests in this version.
    def support_assign_attributes_without_protection?
      @support_assign_attributes ||= ActiveRecord::VERSION::STRING >= "3.1.0"
    end
  end

  class ProxyTestCase < TestCase
    def setup
      @product   = Product.new
      @localized = @product.localized
      @supplier  = Supplier.new
      @supplier_localized = @supplier.localized
      @user = User.new
      @user_localized = @user.localized
      @person = Person.new
      @person_localized = @person.localized

      I18n.locale = :pt
    end

    def teardown
      I18n.locale = :en
    end
  end
end
