class Doors::Commands::Start

  def initialize(argv, cli)
    @cli = cli
    @project_name = argv.first
  end

  def run!
    @cli.project = @project_name
    @cli.tracker.start!
    @cli.git.sync!
  end

end
