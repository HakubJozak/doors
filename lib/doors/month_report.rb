class Doors::MonthReport

  attr_reader :total, :entries, :date

  def initialize(date)
    @date = date
    @entries = []
    @total = 0
  end

  def insert(entry)
    return unless entry.date == @date
    @total += entry.duration
    @entries << entry
  end

end
