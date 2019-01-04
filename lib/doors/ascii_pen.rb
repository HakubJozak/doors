module AsciiPen

  def text
    @io = StringIO.new
    components.each { |s| @io.puts(s) }
    @io.string    
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
