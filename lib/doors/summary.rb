class Doors::Summary
  def initialize(entries)
    compute! entries
  end
  
  def [](project)
    if @projects.has_key?(project)
      @projects[project]
    else
      0
    end
  end

  def total
    @projects.values.sum
  end

  def to_s
    @projects.each_pair.map { |date,dur|
      "#{date}: #{dur}"
    }.to_s
  end

  private
    def compute!(entries)
      @projects = {}

      entries.each do |e|
        @projects[e.project] ||= 0
        @projects[e.project] += e.duration
      end
    end
end
