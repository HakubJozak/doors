require 'date'

class Doors::DateFilter

  def initialize(cli_option, now = Time.now)
    today  = now.to_date

    case cli_option
    when /-(\d)+(m|month|months)?/
      @from = today.prev_month($1.to_i).beginning_of_month
      @to = @from.end_of_month
    else
      @from = today.beginning_of_month
      @to = today.end_of_month
    end
  end

  def duration_in_days
    (@to - @from).to_i + 1
  end

  def to_s
    "#{@from} - #{@to}, #{duration_in_days} days"
  end

  # def last_year
  #   @dates ||= 12.times.map { |i| @today << i }.reverse
  # end
  
  def months
    since = @from.beginning_of_month
    till  = @to.beginning_of_month
    months = []
    
    begin
      months << Month.new(since.year, since.month)
      since = since.next_month
    end while (since < till)

    months
  end

  class Month < Struct.new(:year, :month)
  end

end
