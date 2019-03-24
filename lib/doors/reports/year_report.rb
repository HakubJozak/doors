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


class Doors::YearReport

  def initialize
    @months = Hash.new { |hash, key| hash[key] = EntrySum.new }
  end

  def each(&block)
    @months.each(&block)
  end

  def insert(entry)
    key = key_for_entry(entry)
    @months[key].duration += entry.duration
    @months[key].tasks    << entry.task
  end

  private
    class EntrySum
      attr_accessor :tasks, :duration

      def initialize
        @tasks = []
        @duration = 0
      end
    end    

    def key_for_entry(entry)
      entry.date.strftime("%B %Y")
    end

end
