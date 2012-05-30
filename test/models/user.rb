class User
  include I18n::Alchemy
  attr_accessor :created_at

  localize_methods :created_at => I18n::Alchemy::DateParser
end