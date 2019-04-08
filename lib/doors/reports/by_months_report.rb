class Doors::ByMonthsReport

  attr_reader :name

  def initialize(name:, &block)
    @months = Hash.new { |hash, key| hash[key] = Month.new }
    @name   = name
    @filter = block if block_given?
  end

  def each(&block)
    @months.each(&block)
  end

  def insert(entry)
    return unless passes_filter?(entry)
    key = key_for_entry(entry)
    @months[key].add(entry)
    @months[key].report.insert(entry)
  end

  private
    def key_for_entry(entry)
      entry.date.strftime("%B %Y")
    end

    def passes_filter?(entry)
      return true unless @filter
      @filter.call(entry)
    end

    class Month < EntrySum
      attr_reader :report

      def initialize
        super
        @report = Doors::ByDaysReport.new
      end
    end

end
