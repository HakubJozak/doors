require 'date'
require 'yaml'

require_relative 'entry'


class Doors::Tracker

  def initialize(root)
    @path = "#{root}/running"
    # Doors::Duration.new(Time.now - self.in).floor
  end

  def start!
    if running?
      puts "Already running from #{started.strftime('%R')}."
      puts "Time elapsed: #{duration}"
    else
      File.open(@path,'w') { |f| f.write(Time.now.to_s) }
      puts "Tracker started"
    end
  end

  def stop!
    system "rm #{@path}" if running?
  end

  private

    def running?
      File.exist?(@path)
    end

    def started
      @started ||= DateTime.parse File.read(@path)
    end

    def duration
      secs = (Time.now - started.to_time).floor
      Doors::Duration.new(total: secs)
    end
  

end
