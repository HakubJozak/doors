class Doors::Printer
  def initialize(store)
    @store = store
    @io = StringIO.new
  end

  def totals
    today = entries.inject(0) { |sum,e|
      if e.date == Date.today
        sum += e.duration
      end

      sum
    }

    @io.puts "Today:   %s" % today
    @io.puts "Month:   %s" % month   
  end

  def summary
    total = 0

    @io.puts "   OCTOBER 2018      "
    line
    format = "   %26s | %5s - %5s |  %10s"

    @store.entries.group_by(&:date).each do |day, entries|
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

  def line
    @io.puts [ "   ", "-" * 60 ].join
  end

  def print(val)
    return if val.nil?
    val.strftime("%H:%M")
  end

end
