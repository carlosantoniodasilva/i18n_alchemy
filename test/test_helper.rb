require "rubygems"
require "bundler/setup"
Bundler.require :test

require 'minitest'
require 'minitest/unit'
Minitest.autorun

require "i18n_alchemy"
require "action_view"
require "active_record"

# Setup I18n after other requires to make sure our locales will override any
# ActiveSupport / ActionView defaults.
I18n.enforce_available_locales = false
I18n.default_locale = :en
I18n.locale = :en
I18n.load_path << Dir[File.expand_path("../locale/*.yml", __FILE__)]

require "db/test_schema"
Dir["test/custom_parsers/*.rb"].each { |file| require File.expand_path(file) }
Dir["test/models/*.rb"].each { |file| require File.expand_path(file) }

module I18n::Alchemy
  class TestCase < Minitest::Test
  end

  class ProxyTestCase < TestCase
    def setup
      @product   = Product.new
      @localized = @product.localized
      @supplier  = Supplier.new
      @supplier_localized = @supplier.localized
      @user = User.new
      @user_localized = @user.localized

      I18n.locale = :pt
    end

    def teardown
      I18n.locale = :en
    end

    private

    def silence_deprecations
      old_silenced = ActiveSupport::Deprecation.silenced
      ActiveSupport::Deprecation.silenced = true
      yield
    ensure
      ActiveSupport::Deprecation.silenced = old_silenced
    end
  end
end
