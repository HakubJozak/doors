class Doors::Commands::Start

  attr_reader :project

  def initialize(argv, tracker, config)
    @tracker = tracker
    @config = config
    parse_project!(argv.first)
  end

  def run!
    @tracker.start!
    write_last_project
    git.sync!    
  end

  private
    def parse_project!(value)
      @project = value ||
                 last_project ||
                 fail(Doors::Error.new("No project selected."))
    end

    def last_project
      File.read(last_file).strip if File.exist?(last_file)
    end

    def write_last_project
      File.open(last_file,'w') { |f| f.write(project) }      
    end

    def last_file
      "#{@config.root}/last"      
    end

    def git
      @git ||= Doors::Git.new(@config)      
    end


end
