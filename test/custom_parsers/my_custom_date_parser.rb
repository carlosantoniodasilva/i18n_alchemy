module MyCustomDateParser
  include I18n::Alchemy::DateParser
  extend self

  def localize(value)
    I18n.localize value, format: :custom
  end

  protected

  def i18n_format
    I18n.t(:custom, scope: [:date, :formats])
  end
end
