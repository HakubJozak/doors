class Doors::DateFilter

  def initialize(interval)
    if interval =~ /(+|-)\d+(w|week|m|month)/
      sign = $1 == 
    else
      sign = -1
    end
  end

  def last_week
    limit = (Date.today - 8)

    @entries.select { |e|
      e.date > limit
    }
  end

  def by_month(month)
    @entries.select { |e|
      e.date.month == month.month &&
        e.date.year  == month.year
    }
  end

end
