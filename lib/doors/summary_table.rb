require 'stringio'

class Doors::SummaryTable

  include AsciiPen

  def initialize(summaries)
    @lines = summaries.map  { |s| row(s) }
  end

  def text
    @io = StringIO.new

    components = [
      top,
      header,
      horizontal_line,
      @lines,
      bottom
    ]

    components.each { |s| @io.puts(s) }
    @io.string
  end

  private
    # TODO: merge with Reporter#projects
    def projects
      [ 'kdm', 'inex', 'facility', 'doors' ]
    end

    def width
      @width ||= @lines.map(&:size).max
    end

    # Result:
    #
    # '|   October   2018  | 00:00:01 | 00:00:01 | 00:00:01  | 20:13:00  |'
    #
    def row(summary)
      sums = projects.map { |p| summary[p] || '-' }
      "| %14s #{ '| %10s  ' * projects.size  }| %10s |" %
        [ summary.name, sums, summary.total ].flatten
    end

    # |     SUMMARY       |  inex    |    kdm   |  doors    |   TOTAL   |
    def header
      "| %14s #{ '| %10s  ' * projects.size  }| %10s |" %
        [ 'SUMMARY', projects, 'TOTAL' ].flatten
    end

end
