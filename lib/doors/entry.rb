class Doors::Entry

  include Doors::TimeOps

  attr_reader :in, :out, :duration

  def initialize(date, info = {})
    if date.is_a? Time
      @date = [ date.year, date.month, date.day ]
      @in = date
    else
      @date = if date.is_a? Date
                [ date.year, date.month, date.day ]
              else
                date
              end

      set_times(info)
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
