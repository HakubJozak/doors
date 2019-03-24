class Doors::TotalReport
  def initialize
    @total = 0
  end

  def insert(entry)
    @total += entry.duration
  end

  def to_s
    @total.to_s
  end

end


