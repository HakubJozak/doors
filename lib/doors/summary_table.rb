require 'stringio'

class Doors::SummaryTable

  def initialize(summaries)
    @lines = summaries.map  { |s| s.as_table_row(projects) }
  end

  def text
    @io = StringIO.new

    components = [
      top(size),
      header,
      horizontal_line(size),
      @lines,
      bottom(size)
    ]

    components.each { |s| @io.puts(s) }
    @io.string
  end

  private
    # TODO: merge with Reporter#projects
    def projects
      [ 'kdm', 'inex', 'facility', 'doors' ]
    end

    def size
      @size ||= @lines.map(&:size).max
    end

    # |     SUMMARY       |  inex    |    kdm   |  doors    |   TOTAL   |
    def header
      "| %14s #{ '| %10s  ' * projects.size  }| %10s |" %
        [ 'SUMMARY', projects, 'TOTAL' ].flatten
    end

    def bottom(size)
      "\\#{ '_' * (size - 2) }/"
    end

    def horizontal_line(size)
      "|#{ '-' * (size - 2) }|"
    end

    def top(size)
      ".#{ '~' * (size - 2) }."
    end
end
