class Doors::EntriesFilter

  def initialize(store)
    @store = store
  end

  def last_week
    limit = (Date.today - 8)

    @store.entries.select { |e|
      e.date > limit
    }
  end

  def by_month(month)
    @store.entries.select { |e|
      e.date.month == month.month &&
        e.date.year  == month.year
    }
  end

end
