class Doors::Summary
  def initialize(name, &condition)
    @condition = condition
    @projects = {}
    @name = name
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

  #
  # '|   October   2018  | 00:00:01 | 00:00:01 | 00:00:01  | 20:13:00  |'
  #
  def as_table_row(projects)
    sums = projects.map { |p| @projects[p] || '-' }
    "| %s #{ '| %10s  ' * projects.size  }| %10s |" %
      [ @name, sums, total ].flatten
  end

  def update(entries)
    entries.each do |e|
      next unless @condition.call(e)
      @projects[e.project] ||= 0
      @projects[e.project] += e.duration
    end    
  end

  def to_s
    vals = @projects.each_pair.map { |date,dur|
      "#{date}: #{dur}"
    }.join(', ')

    [ @name, vals ].join(': ')
  end

  private
    # def compute!(entries)
    #   entries.each do |e|
    #     @projects[e.project] ||= 0
    #     @projects[e.project] += e.duration
    #   end
    # end
end
