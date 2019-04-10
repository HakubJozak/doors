class Doors::Commands::Start

  def initialize(argv, cli)
    @cli = cli
    @project_name = argv.first
  end

  def call
    @cli.project = @project_name
    @cli.tracker.start!
    @cli.git.sync!("IN #{@cli.project}")
  end

end
