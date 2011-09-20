class Account < ActiveRecord::Base
  include I18n::Alchemy

  belongs_to :supplier
end