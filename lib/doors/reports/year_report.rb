class Doors::YearReport

  def initialize
    @months = Hash.new { |hash, key| hash[key] = Month.new }
  end

  def each(&block)
    @months.each(&block)
  end

  def insert(entry)
    key = key_for_entry(entry)
    @months[key].add(entry)
    @months[key].report.insert(entry)
  end

  private
    def key_for_entry(entry)
      entry.date.strftime("%B %Y")
    end

    class Month < EntrySum
      attr_reader :report

      def initialize
        super
        @report = Doors::MonthReport.new
      end
    end

end
