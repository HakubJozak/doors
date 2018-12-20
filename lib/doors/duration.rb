class Doors::Duration

  def initialize(hours = 0, minutes = 0, secs = 0, total: nil)
    if total.nil?
      @seconds = hours * 3600 + minutes * 60 + secs
    else
      @seconds = total
    end

    # fail ArgumentError.new("Zero duration") if @seconds.zero?
  end

  def self.parse(val)
    return if val.nil?
    case val
    when Integer
      # single number is 'hours'
      new(val,0,0)
    when Float
      # float is hours.minutes, 
      hour = val.floor
      new(hour, (val - hour) * 100)
    when /:/
      # 1:33:50
      ary = val.split(':')[0..2].map(&:to_i)
      new(*ary)
    when /(\d+)(h|m)/
      # 2h 30m
      m = val.match(/(?<hours>(\d+)h)?\s*(?<minutes>(\d+)m)?/)
      new(m[:hours].to_i, m[:minutes].to_i)
    else
      fail "Unrecognized duration #{val}"
    end
  end
  
  def +(other)
    self.class.new(total: self.to_i + other.to_i)
  end

  def coerce(other)
    [ self.class.new(total: other), self ]
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
