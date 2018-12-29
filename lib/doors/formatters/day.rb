require 'date'

class Doors::Formatters::Day

  def initialize(today = Date.today)
    @today = today.dup.freeze
    @yesterday = (today - 1).freeze
  end

  def print(date, entries)
    
  end

  
end
