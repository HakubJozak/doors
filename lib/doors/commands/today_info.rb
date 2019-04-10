class Doors::Commands::TodayInfo

  def initialize(argv, cli, today = Date.today)
    @cli = cli
    @today = today
    @report = Doors::ByDaysReport.new
    @entries = []
  end

  def call
    loader.load_months!(@today.beginning_of_month)
    @entries.each do |entry|
      puts " %5s | %2s - %2s | %-10s" %
           [  entry.project, entry.in, entry.out, entry.duration]
      
    end
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
