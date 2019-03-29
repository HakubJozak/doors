require 'date'

class Doors::Formatters::LogFormatter

  def initialize(report, total)
    @report = report
    @total  = total
  end

  def call
    @report.each do |key,sum|
      line

      sum.report.each.with_index do |val, i|
        date, report = val
        number = ('%02d' % date.day).yellow
        day_name = date.strftime("%10A").ljust(10)
        day_name = day_name.yellow if day_name.strip == 'Monday'
        title = key if i == 0

        puts " %14s | %2s %s | %-10s" %
             [ title, number, day_name, report.duration ]
      end

      puts " %14s | %13s | %-12s" % [ 'Total', nil, sum.duration.to_s.red ]      
    end

    line
    puts " %14s | %13s %12s" % [ 'TOTAL', nil, @total ]
  end

  private
    def line
      puts "-" * 46
    end



end
