class Doors::CLI

  include Doors::ProjectSelector

  def run!(argv)
    @command = argv.shift
    execute_command!(argv)
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
    def execute_command!(argv)
      case @command
        when nil, '', 'p', 'print'
          Doors::Commands::Print.new(argv, self).run!
        when nil, '', 'r', 'report'
          r = Doors::Reporter.new(self)
          puts r.projects.inspect
          puts r.entries.inspect
        when 'i', 'in', 'start'
          Doors::Commands::Start.new(argv, self).run!
        when 'o', 'out', 'stop'
          git.sync! if tracker.stop!
        when 's', 'sync'
          git.inline.sync!
        when 'h', 'help'
          help
        when 'i3'
          if ENV['BLOCK_BUTTON'].to_s.empty?
            if tracker.running?
              puts "<span color='green'>IN</span>"
            else
              puts "<span color='red'>OUT</span>"
            end
          else
            puts 'Click!'
            # if @tracker.running?
            #   @git.sync! if @tracker.stop!
            # else
            #   @tracker.start!
            #   @git.sync!
            # end
          end
        else
          help
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

end
