class Doors::CLI

  def initialize
    @tracker = Doors::Tracker.new
  end

  def parse!(args)
    args = args.dup

    if args.empty?
      puts help
    else
      case cmd = args.shift
      when 'i', 'in', 'start'
        @tracker.start!
      when 'o', 'out', 'stop'
        @tracker.stop!
      else
        raise "Unknown commmand"
        # TODO - start or stop
      end

      @tracker.entries.each do |e|
        puts "%26s   %26s  %26s" % [ e.in || '-', e.out || '-', e.duration ]
      end
    end
  end

  def help
    <<~HELP
    Usage:

      d i - (check IN) starts time tracking
      d o - (check OUT) stops time tracking

HELP
end

end
