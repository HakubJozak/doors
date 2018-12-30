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
