require "rubygems"
require "bundler/setup"
Bundler.require :test

require "minitest/unit"
MiniTest::Unit.autorun

require "i18n_alchemy"
I18n.default_locale = :en
I18n.locale = :en
I18n.load_path << Dir[File.expand_path("../locale/*.yml", __FILE__)]

ActiveRecord::Base.establish_connection(
  :adapter  => "sqlite3",
  :database => ":memory:"
)
ActiveRecord::Base.connection.create_table :products do |t|
  t.string     :name
  t.decimal    :price
  t.integer    :quantity
  t.date       :released_at
  t.datetime   :updated_at
  t.timestamp  :last_sale_at
  t.references :supplier
  t.string     :my_precious_attribute
end

# TODO: Change this when is decided to include this module in the gem. Or just keep there! #
class I18n::Alchemy::Proxy
  include ::I18n::Alchemy::Attributes
end

class Product < ActiveRecord::Base
  attr_protected :my_precious_attribute
  include I18n::Alchemy

  def method_with_block
    yield "called!"
  end
end