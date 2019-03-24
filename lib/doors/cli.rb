class Doors::CLI

  include Doors::ProjectSelector

  def run!(argv)
    parse_command(argv.shift, argv).call
  rescue Doors::Error => e
    puts e.message.red
  end

  def config
    @config ||= Doors::Config.new
  end

  def git
    @git ||= Doors::Git.new(self)
  end

  def store
    @store ||= Doors::Store.new(self)
  end

  def tracker
    @tracker ||= Doors::Tracker.new(self)
  end

  private
    def parse_command(name, args)
      case name
      when 'i', 'in', 'start'
        Doors::Commands::Start.new(args, self)
      when 'o', 'out', 'stop'
        Proc.new { git.sync! if tracker.stop! }
      when 's', 'sync'
        Proc.new { git.inline.sync! }
      when /h|help/
        Proc.new { puts help }
      when 'i3'
        Doors::Commands::I3.new(self)
      when /p|print/
        Doors::Commands::History.new(self)
      else
        Doors::Commands::Status.new(self)
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

    def options
      print
    end
    
end
