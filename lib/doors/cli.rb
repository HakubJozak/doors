class Doors::CLI

  def initialize
    ensure_root_exists!
    @store   = Doors::Store.new(root)
    @tracker = Doors::Tracker.new(root, @store)
  end

  def run!(args)
    args = args.dup

    if args.empty?
      summary
    else
      case cmd = args.shift
      when 'i', 'in', 'start'
        @tracker.start!
      when 'o', 'out', 'stop'
        @store.add @tracker.stop!
      when 'h', 'help'
        help
      else
        help
      end
    end
  end

  def help
    <<~HELP
    Usage:

      d   - prints entries summary
      d i - (check IN) starts time tracking
      d o - (check OUT) stops time tracking

    HELP
  end

  def summary
    total = 0

    puts "   OCTOBER 2018      "
    line
    format = "   %26s | %5s - %5s |  %10s"

    @store.entries.group_by(&:date).each do |day, entries|
      day_total = 0

      entries.each.with_index do |e,i|
        title = if i == 0
                  day.strftime("%A %d")
                end

        puts format % [ title, print(e.in), print(e.out), e.duration ]

        total += e.duration
        day_total += e.duration
      end

      puts "  %48s %s" % [ '', day_total ]
    end


    line
    puts "   Total %41s %s" % [ '', total ]

  end

  def line
    puts [ "   ", "-" * 60 ].join
  end

  def print(val)
    return if val.nil?
    val.strftime("%H:%M")
  end

  def root
    "#{ENV['HOME']}/time"
  end

  def ensure_root_exists!
    system "mkdir -p #{root}"
  end


end
