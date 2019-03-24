class Doors::DayReport

  attr_reader :total, :entries, :date

  def initialize
    # Hash with default value
    @days = Hash.new { |hash, key| hash[key] = {} }
  end

  def insert(entry)
    @days[entry.project][entry.date] ||= (day = Day.new)
    day.tasks = [ day.tasks, entry.tasks ].map(&:present).compact.join(', ')
    day.duration = (day.duration || 0) + entry.duration
  end

  private

  class Day < Struct.new(:tasks,:duration)
  end    


end
