class Doors::MonthReport

  attr_reader :total, :entries, :date

  def initialize
    # Hash with default value
    @days = Hash.new { |hash, key| hash[key] = EntrySum.new }
  end

  def each(&block)
    @days.each(&block)
  end

  def insert(entry)
    @days[entry.date].add(entry)
  end

end
