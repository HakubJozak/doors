class Doors::CLI

  def initialize
    ensure_root_exists!
    @store   = Doors::Store.new(root)
    @tracker = Doors::Tracker.new(root, @store)
    @git     = Doors::Git.new(root, @store)
  end

  def run!(args)
    args = args.dup

    if args.empty?
      puts Doors::Printer.new(@store).summary
    else
      case cmd = args.shift
      when 'i', 'in', 'start'
        @tracker.start!
        @git.sync!
      when 'o', 'out', 'stop'
        if entry = @tracker.stop!
          @store.add(entry)
          @store.save!
          @git.sync!
        end
      when 's', 'sync'
        @git.inline.sync!
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

      d [d]     - display summary
      d i[n]   - (check IN) starts time tracking
      d o[out] - (check OUT) stops time tracking
      d s[ync] - (SYNC) synchronizes GIT repo

    HELP
  end

  def root
    "#{ENV['HOME']}/time"
  end

  def ensure_root_exists!
    system "mkdir -p #{root}"
  end


end
