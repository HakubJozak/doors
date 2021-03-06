require 'date'
require 'yaml'
require_relative 'entry'


class Doors::Tracker

  def initialize(cli)
    @cli = cli
    @path = "#{cli.config.root}/running"
  end

  def status
    if running?
      "Running #{@cli.project.light_blue} #{duration}"
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
      puts "#{t.strftime('%R')} - tracking #{@cli.project}"
    end
  end

  def stop!
    if running?
      e = Doors::Entry.new( nil, from: started, to: Time.now )
      @cli.store.add(e)
      @cli.store.save!
      puts "#{@cli.project.light_blue} stopped. Time elapsed: #{duration}"
      system "rm -f #{@path}"
      e
    else
      puts status
      nil
    end
  end

  def running_entry
    return nil unless running?
    RunningEntry.new(started, @cli.project)
  end

  def running?
    File.exist?(@path)
  end

  private
    class RunningEntry

      attr_reader :in, :out, :project

      def initialize(started, project)
        @in = started.to_time
        @out = Time.now
        @project = project
      end

      def date
        t = Date.today
        # TODO - change Entry to store date as Date
        [ t.year, t.month, t.day ]
        t
      end

      # TODO
      def task
        ''
      end

      def duration
        secs = @out.to_time - @in.to_time
        Doors::Duration.new(total: secs)
      end

      def running?
        true
      end

      # running entry is always last
      def <=>(other)
          1
      end
    end

    def started
      @started ||= DateTime.parse File.read(@path)
    end

    def duration
      secs = (Time.now - started.to_time).floor
      Doors::Duration.new(total: secs)
    end


end
