class Doors::Loader

  attr_reader :summaries, :details

  def initialize(cli)
    @cli = cli
    @root = cli.config.root
    @listeners = []
  end

  def load_months!(*months)
    @entries = months.map do |month|
      entries = projects.map do |project|
        file = path_for(project, month)
        parser.load(file, project)
      end.flatten

      notify_listeners!(entries)
    end.flatten.compact
  end

  def register!(*listeners)
    @listeners << listeners
    @listeners.flatten!
    self
  end

  private
    # Example:
    #
    #  ~/time/kdm/october_2018.yml
    #
    def path_for(project, d = Date.today)
      month = d.strftime("#{@root}/#{project}/%Y_%B.yml").downcase
    end

    def notify_listeners!(entries)
      @listeners.each { |s| s.update(entries) }
    end

    def projects
      @projects ||= Dir["#{@root}/*"].map { |f|
        File.basename(f) if File.directory?(f)
      }.compact.freeze
    end

    def parser
      @parser ||= Doors::Parser.new
    end

end
