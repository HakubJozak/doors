class Doors::Commands::I3

  attr_reader :tracker

  def initialize(cli, today = Date.today)
    @cli = cli
    @today = today
    @tracker = cli.tracker
  end  

  def call
    if ENV['BLOCK_BUTTON'].to_s.empty?
      if tracker.running?
        puts "<span color='green'>IN</span>"
      else
        puts "<span color='red'>OUT</span>"
      end
    else
      puts 'Click!'
      # if @tracker.running?
      #   @git.sync! if @tracker.stop!
      # else
      #   @tracker.start!
      #   @git.sync!
      # end
    end

    $stdout.flush
  end
end
