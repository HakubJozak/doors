require 'date'

class Doors::Formatters::LogFormatter

  def initialize(report, total, dates: nil, today: Date.today, &block)
    @report = report
    @total  = total
    @dates  = dates
    @today  = today
  end

  def call
    puts
    puts @dates.to_s
    line

    @report.each do |month_name,sum|

      report_title = @report.name.center(8).blue

      puts " %s | %13s | %-10s   |" %
           [ month_name.rjust(14), nil, report_title ]

      sum.report.each.with_index do |val, i|
        date, report = val
        number = ('%02d' % date.day).yellow

        day_name = date.strftime("%10A").ljust(10)
        day_name = day_name.yellow if day_name.strip == 'Monday'

        puts " %14s | %2s %s | %-10s | %s " %
             [ nil, number, day_name, report.duration, info_for(date)&.green ]
      end

      puts " %14s | %13s | %-12s   |" % [ 'This month', nil, sum.duration.to_s.blue ]
    end

    line
    puts " %s | %13s   %s |" % [ 'TOTAL'.rjust(14).red, nil, @total.to_s.ljust(10).red ]
    puts
  end

  private
    def info_for(date)
      if date == @today
        'today'
      elsif date == (@today - 1)
        'yesterday'
      end
    end
    
    def line
      puts "-" * 57
    end



end
