class Doors::Commands::Start

  include Doors::ProjectSelector
  
  def initialize(argv, tracker, config)
    @tracker = tracker
    @config = config
    @project = selected_project(argv.first)
  end

  def run!
    @tracker.start!
    write_selected_project!(@project)
    git.sync!    
  end

  private

    def git
      @git ||= Doors::Git.new(@config)      
    end


end
