module AsciiPen

  def bottom
    "\\#{ '_' * (width - 2) }/"
  end

  def horizontal_line
    "|#{ '~' * (width - 2) }|"
  end

  def top
    ".#{ '~' * (width - 2) }."
  end

  
end
