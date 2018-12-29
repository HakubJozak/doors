class Doors::EntriesFilter

  def initialize(store)
    @entries = store.entries
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
