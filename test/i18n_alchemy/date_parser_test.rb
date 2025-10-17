require "test_helper"

class DateParserTest < I18n::Alchemy::TestCase
  def setup
    @parser = I18n::Alchemy::DateParser
    @date   = Date.new(2011, 12, 31)
  end

  def test_parses_valid_string_dates_with_default_i18n_locale
    assert_equal @date, @parser.parse("12/31/2011")
  end

  def test_parsers_string_dates_on_current_i18n_locale
    I18n.with_locale :pt do
      assert_equal @date, @parser.parse("31/12/2011")
    end
  end

  def test_parsers_string_dates_with_implicit_day
    I18n.with_locale :jp do
      assert_equal @date.at_beginning_of_month, @parser.parse("12/2011")
    end
  end

  def test_parsers_returns_the_given_string_when_invalid_date
    assert_equal "31/12/2011", @parser.parse("31/12/2011")
  end

  def test_does_not_localize_string_values
    assert_equal "12/31/2011", @parser.localize("12/31/2011")
  end

  def test_localizes_date_values
    assert_equal "12/31/2011", @parser.localize(@date)
  end

  def test_localizes_date_values_based_on_current_i18n_locale
    I18n.with_locale :pt do
      assert_equal "31/12/2011", @parser.localize(@date)
    end
  end

  def test_localizes_date_values_with_implicit_day
    I18n.with_locale :jp do
      assert_equal "12/2011", @parser.localize(@date)
    end
  end
end
