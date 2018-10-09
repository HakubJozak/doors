require 'date'
require 'yaml'

require_relative 'entry'


class Doors::Tracker

  def initialize(root, store)
    @path = "#{root}/running"
    @store = store
    # Doors::Duration.new(Time.now - self.in).floor
  end

  def start!
    if running?
      # puts "Already running from #{started.strftime('%R')}."
      puts "Time elapsed: #{duration}"
    else
      t = Time.now
      File.open(@path,'w') { |f| f.write(t.to_s) }
      puts "#{t.strftime('%R')} - tracker started."
    end
  end

  def stop!
    if running?
      e = Doors::Entry.new( nil, from: started, to: Time.now )
      @store.save!
      puts "Tracker stopped. Time elapsed: #{duration}"
      system "rm -f #{@path}"
      e
    else
      puts "Tracker is not running."
    end
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
