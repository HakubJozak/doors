require 'stringio'

class Doors::Printer2

  def initialize(summaries, days)
    @summaries = summaries
    @days = days
    @io = StringIO.new
  end

  def as_table
    top
    @summaries
      .map  { |s| s.as_table_row(projects) }
      .each { |s| @io.puts(s) }
    bottom
    @io.string
    # @details.map(&:print) ].compact.flatten.join("\n")
  end

  private
    # TODO: merge with Reporter#projects
    def projects
      [ 'kdm', 'inex', 'facility', 'doors' ]
    end
  
    def bottom
      @io.puts '\_________________________________________________________________/'
    end

    def hr
      @io.puts '|~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|'
    end

    def top
      @io.puts '.-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-.'
    end
end
