require "test_helper"

module BaseTimeParserTest
  def test_does_not_convert_non_string_objects
    assert_equal @time, @parser.parse(@time)
  end

  # TODO: why so many time differences on the output?
  def test_parses_valid_string_times_with_default_i18n_locale
    output_timestamp = if RUBY_VERSION < "1.9"
                         "Sat Dec 31 12:15:45 UTC 2011"
                       else
                         "2011-12-31 12:15:45 UTC"
                       end

    assert_equal output_timestamp, @parser.parse("12/31/2011 12:15:45")
  end

  def test_parsers_string_times_on_current_i18n_locale
    I18n.with_locale :pt do
      output_timestamp = if RUBY_VERSION < "1.9"
                           "Sat Dec 31 12:15:45 UTC 2011"
                         else
                           "2011-12-31 12:15:45 UTC"
                         end

      assert_equal output_timestamp, @parser.parse("31/12/2011 12:15:45")
    end
  end

  def test_parsers_returns_the_given_string_when_invalid_time
    assert_equal "31/12/2011 12:15:45", @parser.parse("31/12/2011 12:15:45")
  end

  def test_does_not_localize_string_values
    assert_equal "12/31/2011 12:15:45", @parser.localize("12/31/2011 12:15:45")
  end

  def test_localizes_time_values
    assert_equal "12/31/2011 12:15:45", @parser.localize(@time)
  end

  def test_localizes_time_values_based_on_current_i18n_locale
    I18n.with_locale :pt do
      assert_equal "31/12/2011 12:15:45", @parser.localize(@time)
    end
  end
end

class TimeParserTest < MiniTest::Unit::TestCase
  def setup
    @parser = I18n::Alchemy::TimeParser
    @time   = Time.mktime(2011, 12, 31, 12, 15, 45)
  end

  include BaseTimeParserTest
end


class DateTimeParserTest < MiniTest::Unit::TestCase
  def setup
    @parser = I18n::Alchemy::TimeParser
    @time   = DateTime.new(2011, 12, 31, 12, 15, 45)
  end

  include BaseTimeParserTest
end
