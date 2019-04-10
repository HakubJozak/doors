class Doors::Entry

  include Doors::TimeOps
  include Comparable

  attr_accessor :in, :out, :duration, :task, :project

  # TODO: refactor and merge with ^
  def initialize( date, info = {} )
    @project = info['project']
    @task    = info['task']

    if date.is_a? Time
      @date = [ date.year, date.month, date.day ]
      @in = date
    elsif date
      @date = if date.is_a? Date
                [ date.year, date.month, date.day ]
              else
                date
              end

      set_times(info)
    else
      # HACK merge with new_tracked!
      @in = info[:from]
      @out = info[:to]
      @date = [ @in.year, @in.month, @in.day ]
    end
  end

  def in_month?(month)
    date.month == month.month &&
      date.year  == month.year
  end

  def date
    Date.new(*@date)
  end

  def running?
    false
  end

  def <=>(other)
    @in.to_time <=> other.in.to_time
  end

  private
    def set_times(info)
      if [ info['in'], info['out'], info['duration'] ].all?(&:blank?)
        fail "Blank entry info #{info.inspect}"
      end

      @in = create_time( info['in'] )
      @out = create_time( info['out'] )
      @duration = Doors::Duration.parse( info['duration'] )

      if @in && @out && @duration.nil?
        if @out < @in
          # we overlapped over midnight,
          # add 1 day
          @out += 3600 * 24
        end

        @duration = Doors::Duration.new(total: (@out - @in).floor)
      end
    end

    def create_duration(val)
      return if val.nil?
      time = time_to_array(val)
      Doors::Duration.new(*time)
    end

    def create_time(val)
      return if val.nil?
      time = time_to_array(val)
      Time.new *[ @date, time].flatten
    end

    def time_to_array(time)
      # Converts floats to duration-like strings
      str = time.to_s.gsub('.',':')
      array = str.split(':')[0..2].map(&:to_i)
      array.push(0) while array.size < 2
      array
    end


end
