class Doors::Entry

  include Doors::TimeOps

  def initialize(date, info)
    @date = date
    set_times(info)
  end

  def open?
    @duration.nil? && @out.nil?
  end

  private

    def set_times(info)
      @in = create_time( info['in'] )
      @out = create_time( info['out'] )
      @duration = create_duration( info['duration'] )

      if @in && @out && @duration.nil?
        @duration = Duration.new(secs: (@out - @in).floor)
      end
    end

    def create_duration(val)
      time = time_to_array(val)
      Doors::Duration.new(*time)
    end

    def create_time(val)
      time = time_to_array(val)
      Time.new @date.concat(*time)
    end

    

end
