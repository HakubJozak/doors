class Doors::Entry

  include Doors::TimeOps

  attr_accessor :in, :out, :duration

  # TODO: refactor and merge with ^
  def initialize( date, info = {} )
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

  def to_hash
    f = '%H:%M:%S'

    if @in && @out
      [ @in.strftime(f), @out.strftime(f) ].join(' - ')
    elsif @out
      { 'out' => @out.strftime(f) }
    elsif @in
      { 'in'  => @in.strftime(f) }
    elsif @duration
      @duration.to_s
    end
  end

  def date
    Date.new(*@date)
  end

  private

    def set_times(info)
      @in = create_time( info['in'] )
      @out = create_time( info['out'] )
      @duration = create_duration( info['duration'] )

      if @in && @out && @duration.nil?
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



end
