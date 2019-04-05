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
    loader.load_months!(*date_filter.months)
    puts formatter.()
  end

  private
    def loader
      @loader ||= begin
                    l = Doors::Loader.new(@cli, project: project)
                    l.add_listeners total, monthly
                  end
    end

    def formatter
      @formatter = Doors::Formatters::LogFormatter.
                     new(monthly, total, dates: date_filter)
    end

    def total
      @total_report ||= Doors::TotalReport.new
    end

    def monthly
      @month_report ||= Doors::YearReport.new
    end

    def date_filter
      Proc.new { |entry|  true }
    end

    def option_parser
      OptionParser.new do |p|
        # p.on '-v', '--verbose', 'More verbose summary' do
        #   @verbose = true
        # end

        p.on '-t TAG', '--tags TAG', String,
             'Only entries with task containing [TAG] will be listed.' do
          # TODO
          # loaders.add_filter
        end

        p.on '-p PROJECT', '--project PROJECT', String,
             'Limit entries to PROJECT' do |p|
          debug "Using project #{p}"
          @project = p
        end

        p.on '-i INTERVAL', '--interval INTERVAL', String,'Date interval' do |int|
          debug "Using interval #{int}"

          # loader.add_filter
        end
      end
    end

    def debug(msg)
      $stderr.puts(msg.gray)
    end

end
