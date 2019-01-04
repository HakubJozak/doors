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

  def name
    @month.strftime('%B %Y')
  end

  def total
    @projects.values.sum
  end

  def insert(entry)
    return unless entry.in_month?(@month)
    @projects[entry.project] ||= 0
    @projects[entry.project] += entry.duration
  end

end
