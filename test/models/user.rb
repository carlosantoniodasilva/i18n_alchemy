class User
  include I18n::Alchemy
  attr_accessor :created_at

  localize :created_at => I18n::Alchemy::DateParser
end
