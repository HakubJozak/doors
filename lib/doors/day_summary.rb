class Doors::DaySummary

  def initialize(date)
    @date = date
    @entries = []
  end

  def insert(entry)
    return unless entry.date == @date
    @entries << entry 
  end

  def print
    " day_summary "
  end


end
