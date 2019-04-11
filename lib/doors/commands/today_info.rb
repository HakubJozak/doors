class Doors::Commands::TodayInfo

  def initialize(argv, cli, today = Date.today)
    @cli = cli
    @today = today
    @report = Doors::ByDaysReport.new
    @entries = [ cli.tracker.running_entry ].compact
  end

  def call
    puts "Today - #{@today.strftime('%A - %d %B %Y')}".red
    puts

    loader.load_months!(@today.beginning_of_month)

    @entries.sort.each do |entry|
      from = entry.in&.strftime('%H:%M')
      to   = entry.out&.strftime('%H:%M')
      state = '[running]'.red if entry.running?

      line = " %s | %5s - %5s | %-8s | %6s" %
             [  entry.project.rjust(5).blue, from, to, entry.duration, state]
      line = line.green

      puts line
    end

    puts
    puts 'Total'.red

    stats.each do |project,duration|
      puts " %s | %6s" % [ project.rjust(5).blue, duration.to_s ]
    end

    puts
  end

  def entry_allowed?(entry)
    @today == entry.date.to_date
  end

  def insert(entry)
    @entries << entry
  end

  private
    def stats
      projects = @entries.group_by(&:project)
      projects.each_pair.map do |project,entries|
        [ project, entries.inject(0) { |sum,e| sum + e.duration } ]
      end  
    end

    def loader
      @loader ||= begin
                    l = Doors::Loader.new(@cli)
                    l.add_filter self
                    l.add_listeners @report
                    l.add_listeners self
                  end
    end

end
