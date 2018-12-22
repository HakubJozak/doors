class Doors::Commands::Start

  def initialize(argv, cli)
    @cli = cli
    @project_name = argv.first
  end

  def run!
    @cli.tracker.start!
    @cli.project = @project_name
    @cli.git.sync!
  end

end
