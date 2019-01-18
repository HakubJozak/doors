class Doors::Loader

  include Doors::Naming

  def initialize(cli)
    @cli = cli
    @root = cli.config.root
    @listeners = []
  end

  def load_months!(*months)
    @entries = months.map do |month|
      entries = projects.map do |project|
        file = path_for(project, date: month)
        parser.load("#{@root}/#{file}", project)
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

    def notify_listeners!(entries)
      @listeners.each do |l|
        entries.each do |e|
          l.insert(e)
        end
      end
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
