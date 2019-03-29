require 'optparse'

class Doors::Commands::Log

  attr_reader :project

  def initialize(argv, cli, today = Date.today)
    @cli = cli
    @today = today
    @entries = {}
    option_parser.parse(argv)
  end

  def call
    loader.load_months!(*last_year)
    puts formatter.()
  end

  private
    def loader
      @loader ||= begin
                    l = Doors::Loader.new(@cli)
                    l.register!(total)
                    l.register!(monthly)                    
                  end
    end

    def formatter
      @formatter = Doors::Formatters::LogFormatter.new(monthly, total)
    end

    def last_year
      @dates ||= 12.times.map { |i| @today << i }.reverse
    end

    def total
      @total_report ||= Doors::TotalReport.new      
    end

    def monthly
      @month_report ||= Doors::YearReport.new
    end

    def option_parser
      OptionParser.new do |p|
        p.on '-v', '--verbose', 'More verbose summary' do
          @verbose = true
        end

        p.on '-p NAME', '--project NAME', String,'Project name' do |p|
          @project = p
        end    
      end
    end

end
