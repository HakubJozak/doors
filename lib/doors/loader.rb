class Doors::Loader

  def initialize(cli, project: :all)
    @cli = cli
    @root = cli.config.root
    @listeners = []
    @filters   = []
    @projects = if project == :all
                  Dir["#{@root}/*"].map { |f|
                    File.basename(f) if File.directory?(f)
                  }.compact.freeze
                else
                  @project   = [ project ]
                end
  end

  def load_months!(*months)
    @entries = months.map do |month|
      entries = @projects.map do |project|
        file = path_for(project, month)
        parser.load(file, project)
      end.flatten

      notify_listeners!(entries)
    end.flatten.compact
  end

  def add_listeners(*listeners)
    @listeners << listeners
    @listeners.flatten!
    self
  end

  def add_filters(*filters)
    @filters << filters
    @filters.flatten!
    self
  end  

  alias :add_listener :add_listeners
  alias :add_filter   :add_filters

  private
    # Example:
    #
    #  ~/time/kdm/october_2018.yml
    #
    def path_for(project, d = Date.today)
      month = d.strftime("#{@root}/#{project}/%Y_%B.yml").downcase
    end

    def notify_listeners!(entries)
      entries.each do |e|
        # debug e.inspect
        @listeners.each do |l|
          l.insert(e)
        end
      end
    end

    def parser
      @parser ||= Doors::Parser.new
    end

end
