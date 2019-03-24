class Doors::MonthReport

  attr_reader :total, :entries, :date

  def initialize
    # Hash with default value
    @days = Hash.new { |hash, key| hash[key] = {} }
  end

  def insert(entry)
    @days[entry.project][entry.date] ||= (day = Day.new)
    day.tasks.append(entry.task).uniq!
    day.duration = day.duration + entry.duration
  end

  private
    class Day < Struct.new(:tasks,:duration)
      def initialize
        super
        @tasks = []
        @duration = 0
      end
    end    

end
