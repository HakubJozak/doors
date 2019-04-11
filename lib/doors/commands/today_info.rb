class Doors::Commands::TodayInfo

  def initialize(argv, cli, today = Date.today)
    @cli = cli
    @today = today
    @report = Doors::ByDaysReport.new
    @entries = [ cli.tracker.running_entry ].compact
  end

  def call
    puts

    loader.load_months!(@today.beginning_of_month)

    @entries.sort.each do |entry|
      from = entry.in&.strftime('%H:%M')
      to   = entry.out&.strftime('%H:%M')
      state = 'RUNNING'.red if entry.running?

      line = " %s | %5s - %5s | %-8s | %6s" %
             [  entry.project.rjust(5).blue, from, to, entry.duration, state]
      line = line.green

      puts line
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

    def loader
      @loader ||= begin
                    l = Doors::Loader.new(@cli)
                    l.add_filter self
                    l.add_listeners @report
                    l.add_listeners self
                  end
    end

end
