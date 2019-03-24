require_relative 'test_helper'


class ParserTest < Minitest::Test

  def setup
    @date = Date.new(2018,12,31)
  end

  def test_new_timespan
    # means 1 hours and 25 minutes
    p = Doors::Parser.new
    e = p.parse_entry(@date, '16:28:04 - 18:15:20 hello world', project: 'inex')
    assert_equal Time.new(2018,12,31,16,28,04), e.in
    assert_equal Time.new(2018,12,31,18,15,20), e.out
    assert_equal 'hello world', e.task
    assert_equal 'inex', e.project
  end


end
