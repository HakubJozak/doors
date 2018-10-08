class Doors::Duration

  def initialize(hours = 0, minutes = 0, secs = 0, total: nil)
    if total.nil?
      @seconds = hours * 3600 + minutes * 60 + secs
    else
      @seconds = total
    end

    fail ArgumentError.new("Zero duration") if @seconds.zero?
  end

  def hours
    @seconds.div 3600
  end

  def minutes
    (@seconds - hours*3600).div 60
  end

  def secs
    @seconds - (minutes*60 + hours*3600)
  end

  def to_i
    @seconds
  end

  def to_s
    "%02d:%02d:%02d" % 
      [ hours, minutes, secs ]
  end

end
