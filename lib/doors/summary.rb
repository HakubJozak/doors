class Doors::Summary

  def initialize(month)
    @projects = {}
    @month = month
  end

  def [](project)
    if @projects.has_key?(project)
      @projects[project]
    else
      nil
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
