class String

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def blue
    colorize(34)
  end

  def magenta
    colorize(35)
  end

  alias :violet :magenta

  def light_blue
    colorize(36)
  end

  def gray
    colorize(37)
  end

  def light_gray
    colorize(92)
  end

  private
    def colorize(color_code)
      "\e[#{color_code}m#{self}\e[0m"
    end

end
