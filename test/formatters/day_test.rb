class Doors::Formatter::DayTest
  def setup
    @today = Date.new(2018,11,20)
  end

  def test_print
    

    formatter = Doors::Formatters::Day.new(@today)
    formatter.print(@today, entries)

"""
|  Monday 27       5:52     |  kdm     | 23:22 - 23:22 | 00:00:09 |
| (yesterday)               |  inex    | 23:24 - 23:25 | 01:00:10 |
|                           |  inex    | 10:00 - 11:00 | 02:00:10 |
|                                                        03:10:00 |    
"""
  end
end
