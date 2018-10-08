require_relative 'test_helper'


class DurationTest < Minitest::Test

  def test_from_hours
    d = Doors::Duration.new(12,45,3)
    assert_equal 12, d.hours
    assert_equal 45, d.minutes
    assert_equal 3, d.secs
    assert_equal 45903, d.to_i
  end

  def test_from_total
    d = Doors::Duration.new(total: 3604)
    assert_equal 4, d.secs
    assert_equal 0, d.minutes
    assert_equal 1, d.hours
    assert_equal 3604, d.to_i
  end
  
end
