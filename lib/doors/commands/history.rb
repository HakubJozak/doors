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

    size = 50

    puts "Summary of #{project.yellow}   "

    monthly.each do |key,sum|
      puts "-" * size
      sum.report.each.with_index do |val, i|
        date, report = val
        number = ('%02d' % date.day).yellow
        day_name = date.strftime("%A")        
        title = key if i == 0

        puts " %14s | %2s %-10s | %-10s" %
             [ title, number, day_name, report.duration ]
      end

      puts " %14s | %13s | %-12s" % [ 'Total', nil, sum.duration.to_s.red ]      
    end

    puts "-" * size
    puts " %14s | %13s %12s" % [ 'TOTAL', nil, total ]
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
