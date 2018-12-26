module Doors::ProjectSelector

  def project=(str)
    return unless str.present?
    @project = str
    write_last_project!
    str
  end

  def project
    @project ||
      last_project ||
      no_project_error!
  end

  private
    def no_project_error!
      fail(Doors::Error.new("No project selected."))
    end

    def last_project
      File.read(last_file).presence if File.exist?(last_file)
    end

    def write_last_project!
      File.open(last_file,'w') { |f| f.write(project) }
    end

    def last_file
      "#{config.root}/last"
    end

end
