require 'date'
require 'yaml'
require_relative 'entry'


class Doors::Tracker

  def initialize(config, store)
    @path = "#{config.root}/running"
    @store = store
  end

  def status
    if running?
      "Tracker running #{duration}"
    else
      "Tracker is not running."
    end
  end

  def start!
    if running?
      # puts "Already running from #{started.strftime('%R')}."
      puts status
    else
      t = Time.now
      File.open(@path,'w') { |f| f.write(t.to_s) }
      puts "#{t.strftime('%R')} - tracker started."
    end
  end

  def stop!
    if running?
      e = Doors::Entry.new( nil, from: started, to: Time.now )
      @store.add(e)
      @store.save!
      puts "Tracker stopped. Time elapsed: #{duration}"
      system "rm -f #{@path}"
      e
    else
      puts status
      nil
    end
  end

  def running?
    File.exist?(@path)
  end

  private

    def started
      @started ||= DateTime.parse File.read(@path)
    end

    def duration
      secs = (Time.now - started.to_time).floor
      Doors::Duration.new(total: secs)
    end


end
