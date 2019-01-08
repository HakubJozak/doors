class Doors::DaySummary

  def initialize(date:, name: nil)
    @projects = {}
    @date = date
    @name = name
  end

  def [](project)
    if @projects.has_key?(project)
      @projects[project]
    else
      nil
    end
  end

  def name
    @name || @date.strftime('%B %d')
  end

  def total
    @projects.values.sum
  end

  def insert(entry)
    return unless entry.date == @date
    @projects[entry.project] ||= 0
    @projects[entry.project] += entry.duration
  end

end
