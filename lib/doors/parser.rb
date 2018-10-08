class Doors::Parser

  include Doors::TimeOps

  def load!(path)
    years = YAML.load_file(path)
    result = []

    years.each do |year,months|
      months.each do |name,days|
        month = to_month(name)

        days.each do |day,entries|
          date = [ year, month, day.to_i ]

          entries.map do |e|
            result << case e
                      when Integer, Float
                        d = Duration.new(time_to_array(e))
                        Doors::Entry.new(date, duration: d)
                      else
                        Doors::Entry.new(date, e)
                      end
          end
        end
      end
    end
  end

  private

    def to_month(val)
      m = DateTime.strptime(val.to_s, '%B').month
    rescue ArgumentError
      month = val.to_i
      fail "Invalid month" if month < 1 || month > 12
      month
    end
  
end
