class Doors::Parser

  include Doors::TimeOps

  def load(path, project = nil)
    return [] unless File.exist?(path)

    years = YAML.load_file(path) || {}
    result = []
    @project = project

    years.each do |year,months|
      months.each do |name,days|
        month = to_month(name)

        days.each do |day,entries|
          @date = [ year, month, day.to_i ]

          if entries.nil? || entries.empty?
            next
          end

          entries.map do |e|
            result << case e
                      when Integer, Float
                        create_entry('duration' => e)
                      when String
                        if e.include? '-'
                          a, b = e.split('-')
                          create_entry('in' => a, 'out' => b)
                        else
                          create_entry('duration' => e)
                        end
                      when Hash
                        create_entry(e)
                      else
                        fail "Unrecognized entry format #{e.inspect}"
                      end
          end
        end
      end
    end

    result
  end

  private
    def create_entry(info)
      Doors::Entry.new(@date, info.merge('project' => @project))
    end

    def to_month(val)
      m = DateTime.strptime(val.to_s, '%B').month
    rescue ArgumentError
      month = val.to_i
      fail "Invalid month" if month < 1 || month > 12
      month
    end

end
