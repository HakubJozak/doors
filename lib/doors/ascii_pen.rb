module AsciiPen

  def text
    components.flatten.join("\n")
  end

  def width
    16 + 12 + projects.size * 15
  end

  def bottom
    "\\#{ '_' * (width - 2) }/"
  end

  def line
    "|#{ '~' * (width - 2) }|"
  end

  def top
    ".#{ '~' * (width - 2) }."
  end


end
