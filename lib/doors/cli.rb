class Doors::CLI

  def initialize
    @config  = Doors::Config.new
    @store   = Doors::Store.new("#{@config.root}/#{project}")
    @tracker = Doors::Tracker.new(@config, @store)
    @git     = Doors::Git.new(@config, @store)
  end

  def run!(args)
    args = args.dup

    if args.empty?
      puts Doors::Printer.new(@store).summary
      puts "        %28s %s" % [ '', @tracker.status ]
      puts "   " + "~" * 60
    else
      case cmd = args.shift
      when 'i', 'in', 'start'
        @tracker.start!
        @git.sync!
      when 'o', 'out', 'stop'
        @git.sync! if @tracker.stop!
      when 's', 'sync'
        @git.inline.sync!
      when 'h', 'help'
        help
      else
        help
      end
    end
  end

  def project
    File.basename(`pwd`.strip)
  end

  def help
    <<~HELP
    Usage:

      d [d]     - display summary
      d i[n]   - (check IN) starts time tracking
      d o[out] - (check OUT) stops time tracking
      d s[ync] - (SYNC) synchronizes GIT repo

    HELP
  end



end
