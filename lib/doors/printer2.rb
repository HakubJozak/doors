require 'stringio'

class Doors::Printer2

  def initialize(summaries, days)
    @summaries = summaries
    @days = days
    @io = StringIO.new
  end

  def as_table
    lines = @summaries.map  { |s| s.as_table_row(projects) }
    size = lines.first.size

    top(size)
    lines.each { |s| @io.puts(s) }
    bottom(size)
    @io.string
    # @details.map(&:print) ].compact.flatten.join("\n")
  end

  private
    # TODO: merge with Reporter#projects
    def projects
      [ 'kdm', 'inex', 'facility', 'doors' ]
    end
  
    def bottom(size)
      @io.puts "\\#{ '_' * (size - 2) }/"
    end

    def hr(size)
      @io.puts "|#{ '~' * (size - 2) }|"
    end

    def top(size)
      @io.puts ".#{ '~-' * (size - 2).div(2) }."
    end
end
