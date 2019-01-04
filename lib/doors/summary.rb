class Doors::Summary

  def initialize(month)
    @projects = {}
    @month = month
  end

  def [](project)
    if @projects.has_key?(project)
      @projects[project]
    else
      0
    end
  end

  def accepts?(entry)
    entry.in_month?(@month)
  end

  def name
    @month.strftime('%B %Y')
  end

  def total
    @projects.values.sum
  end

  # Result:
  #
  # '|   October   2018  | 00:00:01 | 00:00:01 | 00:00:01  | 20:13:00  |'
  #
  def as_table_row(projects)
    sums = projects.map { |p| @projects[p] || '-' }
    "| %14s #{ '| %10s  ' * projects.size  }| %10s |" %
      [ name, sums, total ].flatten
  end

  def update(entries)
    entries.each do |e|
      next unless accepts?(e)
      @projects[e.project] ||= 0
      @projects[e.project] += e.duration
    end
  end

  def to_s
    vals = @projects.each_pair.map { |date,dur|
      "#{date}: #{dur}"
    }.join(', ')

    [ name, vals ].join(': ')
  end

end
