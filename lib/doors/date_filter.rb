require 'date'

class Doors::DateFilter

  def initialize(cli_option, now = Time.now)
    @today  = now.to_date

    case cli_option
    when /^(\d{4})\z/
      year = $1.to_i
      @from = Date.new(year,1,1)
      @to = Date.new(year,12,31)
      @title = year.to_s
    when '',nil
      pick_last_month
      @title = @today.strftime('%B %Y')
    else
      @from = Date.parse(cli_option).beginning_of_month
      @to = @from.end_of_month
      @title = @from.strftime('%B %Y')
    end

  rescue ArgumentError
    retry unless $!.message == 'invalid date'
    pick_last_month
  end

  def entry_allowed?(entry)
    @from <= entry.date &&
      @to >= entry.date
  end

  def duration_in_days
    (@to - @from).to_i + 1
  end

  def to_s
    @title ||
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
      months << since
      since = since.next_month
    end while (since <= till)

    months
  end

  private
    def pick_last_month
        @from = @today.beginning_of_month
        @to = @today.end_of_month
    end



end
