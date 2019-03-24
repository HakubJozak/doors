require 'optparse'

class Doors::Commands::History

  attr_reader :project

  def initialize(argv, cli, today = Date.today)
    @cli = cli
    @today = today
    @entries = {}
    option_parser.parse(argv)
  end

  def call
    @project = @cli.project unless @project
    @total = 0

    loader.register!(total)
    loader.register!(monthly)
    loader.load_months!(*last_year)

    size = 30

    puts "Summary of #{project.yellow}   "
    puts "-" * 30

    monthly.each do |key,sum|
      puts " %14s | %10s" % [ key, sum.duration ]      
      sum.report.each do |day, report|
        date = day.strftime("%d %A")

        puts " %14s | %10s | %10s" % [ '', date, report.duration ]
      end

    end

    # last_year.each do |date|
    #   key   = key_from_date(date)
    #   value = @entries[key] || '-'

    #   puts " %14s | %10s" % [ key, value ]
    # end

    puts "-" * 30
    puts " %14s | %10s" % [ 'TOTAL', total ]

  end

  private
    def loader
      @loader ||= Doors::Loader.new(@cli)
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
