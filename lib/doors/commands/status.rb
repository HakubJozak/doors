class Doors::Commands::Status

  def initialize(cli, today = Date.today)
    @cli = cli
    @today = today
    @this_month = @today
  end


  def run!
    create_counters!
    loader.register! @summaries
    loader.register! @days    
    loader.load_months!(@today, @today << 1)
    # p = Doors::Printer2.new(@summaries, @days)
    puts Doors::SummaryTable.new(@summaries).text
  end

  private
    def create_counters!
      @summaries = [ @today << 1, @today ].map do |month|
	Doors::Summary.new(month)
      end

      @days =  [ @today , @today << 1 ].map do |day|
        Doors::DaySummary.new(day)
      end
    end

    def loader
      @loader ||= Doors::Loader.new(@cli)
    end

end
