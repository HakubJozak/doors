require_relative 'test_helper'


class Doors::DateFilterTest < Minitest::Test

  def setup
    @now  = Time.new(2018,10,31,9,30,0)
  end

  def test_empty_string
    filter = Doors::DateFilter.new(' ', now = @now)
    assert_equal 31, filter.duration_in_days
    assert_equal "2018-10-01 - 2018-10-31, 31 days", filter.to_s

    assert_equal filter.months, [ Date.new(2018,10,1) ]
  end

  def test_last_month
    filter = Doors::DateFilter.new('september', now = @now)
    assert_equal "2019-09-01 - 2019-09-30, 30 days", filter.to_s
    assert_equal 30, filter.duration_in_days
  end

  def test_last_month
    filter = Doors::DateFilter.new('september', now = @now)

    year = Date.today.year
    assert_equal "#{year}-09-01 - #{year}-09-30, 30 days", filter.to_s
    assert_equal 30, filter.duration_in_days
  end  
end

