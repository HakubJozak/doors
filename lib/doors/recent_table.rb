require 'stringio'

class Doors::RecentTable

  include AsciiPen

  attr_reader :projects
  
  def initialize(days, projects)
    @days = days
    @projects = projects
  end

  def components
    [
      top,
      line,
      bottom
    ]
  end

end
