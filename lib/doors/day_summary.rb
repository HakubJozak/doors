class Doors::DaySummary

  def initialize(date)
    @date = date
    @entries = []
  end

  def update(entries)
    entries.each do |e|
      @entries << e if e.date == @date
    end  
  end

  def print
    " day_summary "
  end

  
end
