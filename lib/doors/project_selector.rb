module Doors::ProjectSelector

  def project=(str)
    return if str.empty?
    @project = str
    write_last_project!
    str
  end

  def project
    @project ||
      last_project ||
      fail(Doors::Error.new("No project selected."))    
  end

  

  private
    def last_project
      File.read(last_file).strip if File.exist?(last_file)
    end

    def write_last_project!
      File.open(last_file,'w') { |f| f.write(project) }
    end

    def last_file
      "#{config.root}/last"
    end

end
