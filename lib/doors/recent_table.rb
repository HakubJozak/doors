require 'stringio'

class Doors::RecentTable

  include AsciiPen

  attr_reader :projects

  def initialize(days, projects)
    @projects = projects
    @lines = days.map { |d| [ day(d), line ] }
  end

  def components
    [
      top,
      @lines,
    ].flatten
  end

  def width
    67
  end

  private
    # Examples
    #
    # |  Tuesday 27               |  kdm     | 23:22 - 23:22 | 00:00:09 |
    # |   [today]                 |  inex    | 23:24 - 23:25 | 01:00:10 |
    # |                           |  inex    | 10:00 - 11:00 | 02:00:10 |
    # |                                                        03:10:00 |
    #
    def day(record)
      return empty_day(record) if record.entries.empty?

      record.entries.map.with_index do |entry,i|
        label = date_and_total(record) if i == 0
        label = tag(record) if i == 1

        "| %25s | %8s | %13s | %8s |" %
          [ label,
            entry.project,
            time_span(entry),
            entry.duration ]
      end.join("\n")
    end

    def empty_day(record)
      a = "| %25s | %8s | %13s | %8s |" % [ date_and_total(record), nil, nil, nil ]
      b = "| %25s | %8s | %13s | %8s |" % [ tag(record), nil, nil, nil ]
      [ a, b ]
    end

    def date_and_total(record)
      "%10s %12s " %
        [ record.date.strftime("%A %d"), record.total ]
    end

    def time_span(entry)
      [ time(entry.in), time(entry.out) ].join(' - ')
    end

    def tag(record)
      today = Date.today

      str = if record.date == today
              color = :light_green
              '[today]'
            elsif record.date == today - 1
              color = :gray
              '[yesterday]'
            else
              color = :red
              nil
            end

      ("%11s %12s " % [ str, '  ' ]).public_send(color)
    end

    def time(val)
      return if val.nil?
      val.strftime("%H:%M")
    end

end
