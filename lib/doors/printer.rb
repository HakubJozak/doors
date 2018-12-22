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
  def summary(month)
    # entries = @store.filter.last_week
    entries = @store.filter.by_month(month)

    month_header(month)
    horizontal_ruler

    entries.group_by(&:date).each do |day, entries|
      detailed_day( day, entries)
    end

    horizontal_ruler
    total_info(entries)

    @io.string
  end

  def total_info(entries)
    total = entries.inject(0) { |total,e| total += e.duration }
    puts "   Total %41s %s" % [ '', total ]
  end

  def detailed_day(day, entries)
    day_total = 0
    format = "   %26s | %5s - %5s |  %10s"

    entries.each.with_index do |e,i|
      title = if i == 0
                day.strftime("%A %d")
              end

      puts(format % [ title, print(e.in), print(e.out), e.duration ])

      day_total += e.duration
    end

    puts "  %48s %s" % [ '', day_total ]
  end

  def month_header(month)
    puts month.strftime("   %B %Y")
  end

  def horizontal_ruler
    puts [ "   ", "-" * 60 ].join
  end

  def print(val)
    return if val.nil?
    val.strftime("%H:%M")
  end

  def puts(*args)
    @io.puts *args
  end
end
