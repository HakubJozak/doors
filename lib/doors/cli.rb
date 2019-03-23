class Doors::CLI

  include Doors::ProjectSelector

  def run!(argv)
    command = create_command_object(argv.shift, argv)
    command.call
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
    def create_command_object(name, args)
      cmd = case name
            when nil, 'p', 'print'
              Doors::Commands::Status.new(self)
            when 'i', 'in', 'start'
              Doors::Commands::Start.new(args, self)
            when 'o', 'out', 'stop'
              Proc.new { git.sync! if tracker.stop! }
            when 's', 'sync'
              Proc.new { git.inline.sync! }
            when 'h', 'help'
              Proc.new { puts help }
            when 'i3'
              Doors::Commands::I3.new(self)
            else
              Proc.new { help }
            end

    end

    def help
      cmd = File.basename($PROGRAM_NAME)

      <<~HELP
      Usage:

        #{cmd} [d]     - display summary
        #{cmd} i[n]   - (check IN) starts time tracking
        #{cmd} d o[out] - (check OUT) stops time tracking
        #{cmd} s[ync] - (SYNC) synchronizes GIT repo

      HELP
    end

end
