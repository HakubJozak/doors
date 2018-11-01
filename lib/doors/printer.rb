class Doors::Printer
  def initialize(store)
    @store = store
    @io = StringIO.new
  end

  # def totals
  #   today = entries.inject(0) { |sum,e|
  #     if e.date == Date.today
  #       sum += e.duration
  #     end

  #     sum
  #   }

  #   @io.puts "Today:   %s" % today
  #   @io.puts "Month:   %s" % month
  # end

  def this_month_entries
    @store.entries.select { |e|
      e.date.month == today.month &&
        e.date.year  == today.year
    }
  end

  def summary
    total = 0

    month_header
    line
    format = "   %26s | %5s - %5s |  %10s"

    this_month_entries.group_by(&:date).each do |day, entries|
      day_total = 0

      entries.each.with_index do |e,i|
        title = if i == 0
                  day.strftime("%A %d")
                end

        @io.puts format % [ title, print(e.in), print(e.out), e.duration ]

        total += e.duration
        day_total += e.duration
      end

      @io.puts "  %48s %s" % [ '', day_total ]
    end

    line

    @io.puts "   Total %41s %s" % [ '', total ]

    @io.string
  end

  def month_header
    @io.puts today.strftime("   %B %Y")
  end

  def today
    Date.today
  end
  
  def line
    @io.puts [ "   ", "-" * 60 ].join
  end

  def print(val)
    return if val.nil?
    val.strftime("%H:%M")
  end

end
