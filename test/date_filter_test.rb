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
    assert_equal "September #{year}", filter.to_s
    assert_equal 30, filter.duration_in_days
  end

  def test_year
    filter = Doors::DateFilter.new('2017', now = @now)
    assert_equal "2017", filter.to_s
    assert_equal 365, filter.duration_in_days

    year_2017 = 12.times.map { |i| Date.new(2017,i+1,1) }
    assert_equal year_2017, filter.months
  end  

end
