require 'optparse'

class Doors::CLI

  include Doors::ProjectSelector

  attr_reader :command

  def initialize(argv)
    @command = parse_command(argv.shift, argv)
  end

  def call
    @command.call
  rescue Doors::Error => e
    print_error_and_exit(e.message)
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
        Proc.new {
          Doors::Commands::Start.new(args, self).call
          Doors::Commands::TodayInfo.new(args, self).call
        }
      when 'o', 'out', 'stop'
        Proc.new { git.sync!('OUT') if tracker.stop! }
      when 's', 'sync'
        Proc.new { git.inline.sync! }
      when /h|help/
        Proc.new { puts help }
      when 'i3'
        Doors::Commands::I3.new(self)
      when /e|edit/
        Doors::Commands::Edit.new(self)
      when /l|log/
        Doors::Commands::Log.new(args, self)
      else # when /l|log/
        Doors::Commands::TodayInfo.new(args, self)
      end
    rescue OptionParser::MissingArgument => e
      print_error_and_exit e.message
    end

    def help
      <<~HELP
        Usage:

          t i[n]    - (check IN) starts time tracking
          t o[out]  - (check OUT) stops time tracking
          t s[ync]  - (SYNC) synchronizes GIT repo
          t l[og]   - show log
          t e[dit]  - edit current time sheet

        HELP
    end

    def print_error_and_exit(msg)
      puts msg.red
      exit 1
    end


end
