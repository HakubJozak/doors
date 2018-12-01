class Doors::CLI

  def initialize
    @config  = Doors::Config.new
    @store   = Doors::Store.new("#{@config.root}/#{project}")
    @tracker = Doors::Tracker.new(@config, @store)
    @git     = Doors::Git.new(@config, @store)
  end

  def run!(args)
    args = args.dup

    command = if args.first&.start_with?('-')
                nil
              else
                args.shift
              end

    @options = Doors::CLIOptions.new(args)

    execute_command!(command)
  end

  private
    def execute_command!(command)
      case command
        when nil, '', 'p', 'print'
          puts printer.summary(@options.month)
          puts "        %28s %s" % [ '', @tracker.status ]
          puts "   " + "~" * 60
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
      'kdm'
    end

    def printer
      @printer ||= Doors::Printer.new(@store)
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
