require_relative 'test_helper'


class EntryTest < Minitest::Test

  def setup
    @date = Date.new(2018,12,31)
  end

  def test_new_integer
    e = Doors::Entry.new(@date, 'duration' => 3)
    assert_equal 3 * 3600 , e.duration.to_i
  end

  def test_new_float
    # means 1 hours and 25 minutes
    e = Doors::Entry.new(@date, 'duration' => 1.25)
    assert_equal 85 * 60 , e.duration.to_i
  end

  def test_new_3h_20m
    e = Doors::Entry.new(@date, 'duration' => '3h 20m')
    assert_nil e.in
    assert_nil e.out
    assert_equal 200 * 60, e.duration.to_i
  end

  def test_new_10m
    e = Doors::Entry.new(@date, 'duration' => '10m')
    assert_equal 10 * 60, e.duration.to_i
  end

  def test_new_1h
    e = Doors::Entry.new(@date, 'duration' => '1h')
    assert_equal 3600, e.duration.to_i
  end


end
