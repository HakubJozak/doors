require 'set'

class Doors::ProjectSet < Set

  def insert(entry)
    return if entry.project.blank?
    add(entry.project)
  end
end
