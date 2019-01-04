require 'stringio'

class Doors::SummaryTable

  include AsciiPen

  attr_reader :projects

  def initialize(summaries, projects)
    @projects = projects
    @lines = summaries.map  { |s| row(s) }
  end

  def components
    [
      top,
      header,
      line,
      @lines,
      bottom
    ].flatten
  end

  private
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
        [ 'SUMMARY', projects.to_a, 'TOTAL' ].flatten
    end

end
