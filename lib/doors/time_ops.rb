module Doors::TimeOps

  def duration_in_secs(str)
    hour.to_i * 3600 + min.to_i * 60 + sec.to_i
  end


end
