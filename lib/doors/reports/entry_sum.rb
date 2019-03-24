class EntrySum
  attr_accessor :tasks, :duration

  def initialize
    @tasks = []
    @duration = 0
  end

  # TODO: coerce
  def add(entry)
    self.duration += entry.duration
    self.tasks    << entry.task    
  end

end    

