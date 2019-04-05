class Date
  def beginning_of_month
    self - self.mday + 1
  end

  def end_of_month
    Date.new(year, month, -1)
  end  
end

