class Doors::Commands::Print

  attr_reader :month

  # TODO - pass Doors::CLI object with public methods
  def initialize(argv, cli)
    @cli = cli
    parse_month!(argv.first)
  end

  def run!
    @cli.git.checkout!
    puts "   Project: #{@cli.project.light_blue}"
    puts printer.summary(month)
    puts "        %28s %s" % [ '', @cli.tracker.status ]
    puts "   " + "~" * 60
  end

  private
    def parse_month!(value)
      @month = case value
               when /^\d+$/
                 Date.new(today.year, m.to_i, 1)
               when /l(ast)?/i
                 today << 1
               else
                 today
               end
    end

    def today
      @today ||= Date.today
    end

    def printer
      @printer ||= Doors::Printer.new(@cli.store)
    end


end
