class Doors::Commands::Status

  def initialize(cli, today = Date.today)
    @cli = cli
    @today = today
    @this_month = @today
    @projects = Doors::ProjectSet.new
  end


  def run!
    @summaries = [ @today << 1, @today ].map do |month|
      Doors::Summary.new(month)
    end

    @days =  [ @today - 1 , @today ].map do |day|
      Doors::DaySummary.new(day)
    end

    loader.register! @projects
    loader.register! @summaries
    loader.register! @days    

    loader.load_months!(@today, @today << 1)

    # p = Doors::Printer2.new(@summaries, @days)
    puts Doors::SummaryTable.new(@summaries, @projects).text
    puts
    puts Doors::RecentTable.new(@days, @projects).text    
  end

  private
    def loader
      @loader ||= Doors::Loader.new(@cli)
    end

end
