module Doors::TimeOps

  def time_to_array(time)
    # Converts floats to duration-like strings
    str = time.to_s.gsub('.',':')
    array = str.split(':')[0..2].map(&:to_i)
    array.push(0) while array.size < 2
    array
  end

  def duration_in_secs(str)
    hour.to_i * 3600 + min.to_i * 60 + sec.to_i
  end  


end


