require "test_helper"

class TimeParserTest < MiniTest::Unit::TestCase
  def setup
    @parser = I18n::Alchemy::TimeParser
    @time   = DateTime.civil(2011, 12, 31, 12, 15, 45)
  end

  def test_does_not_convert_non_string_objects
    assert_equal @time, @parser.parse(@time)
  end

  def test_parses_valid_string_datetimes_with_default_i18n_locale
    assert_equal "2011-12-31T12:15:45+00:00", @parser.parse("12/31/2011 12:15:45")
  end

  def test_parsers_string_datetimes_on_current_i18n_locale
    I18n.with_locale :pt do
      assert_equal "2011-12-31T12:15:45+00:00", @parser.parse("31/12/2011 12:15:45")
    end
  end

  def test_parsers_returns_the_given_string_when_invalid_datetime
    assert_equal "31/12/2011 12:15:45", @parser.parse("31/12/2011 12:15:45")
  end

  def test_does_not_localize_string_values
    assert_equal "12/31/2011 12:15:45", @parser.localize("12/31/2011 12:15:45")
  end

  def test_localizes_datetime_values
    assert_equal "12/31/2011 12:15:45", @parser.localize(@time)
  end

  def test_localizes_datetime_values_based_on_current_i18n_locale
    I18n.with_locale :pt do
      assert_equal "31/12/2011 12:15:45", @parser.localize(@time)
    end
  end
end
