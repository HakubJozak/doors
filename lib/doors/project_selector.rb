module Doors::ProjectSelector

  private
    def selected_project(value = nil)
      @project = value ||
                 last_project ||
                 fail(Doors::Error.new("No project selected."))
    end

    def last_project
      File.read(last_file).strip if File.exist?(last_file)
    end

    def write_selected_project!(value)
      File.open(last_file,'w') { |f| f.write(value) }      
    end

    def last_file
      "#{@config.root}/last"      
    end

end
