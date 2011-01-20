require "rubygems"
require "bundler/setup"
Bundler.require :test

require "minitest/unit"
MiniTest::Unit.autorun

require "i18n-alchemy"
I18n.default_locale = :en
I18n.locale = :en
I18n.load_path << Dir[File.expand_path("../locale/*.yml", __FILE__)]

ActiveRecord::Base.establish_connection(
  :adapter  => "sqlite3",
  :database => ":memory:"
)
ActiveRecord::Base.connection.create_table :products do |t|
  t.string  :name
  t.decimal :price
end

class Product < ActiveRecord::Base
  include I18n::Alchemy
end
