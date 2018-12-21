require_relative 'commands/print'
# require_relative 'commands/start'


class Doors::CLI

  def initialize
    @config  = Doors::Config.new
    @git     = Doors::Git.new(@config)
    @store   = Doors::Store.new("#{@config.root}/#{project}")
    @tracker = Doors::Tracker.new(@config, @store)
  end

  def run!(argv)
    @command = argv.shift
    execute_command!(argv)
  rescue Doors::Git::Error => e
    puts e.message.red
  end

  private
    def execute_command!(argv)
      case @command
        when nil, '', 'p', 'print'
          Doors::Commands::Print.new(argv, @store, @tracker).run!
        when 'i', 'in', 'start'
          @tracker.start!
          @git.sync!
        when 'o', 'out', 'stop'
          @git.sync! if @tracker.stop!
        when 's', 'sync'
          @git.inline.sync!
        when 'h', 'help'
          help
        when 'i3'
          if ENV['BLOCK_BUTTON'].to_s.empty?
            if @tracker.running?
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

    def project
      # File.basename(`pwd`.strip)
      'inex'
      'kdm'
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
