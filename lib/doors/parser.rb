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
          date = [ year, month, day.to_i ]

          if entries.nil? || entries.empty?
            next
          end

          entries.map do |e|
            result << case e
                      when Integer, Float
                        create_entry(date, 'duration' => e)
                      when String
                        parse_entry(date, e, project: @project)
                      when Hash
                        create_entry(date, e)
                      else
                        fail "Unrecognized entry format #{e.inspect}"
                      end
          end
        end
      end
    end

    result
  end

  # 10m
  #  2h
  #  3h 20m
  REG_HOURS = /(?<hours>\d+)h/

  REG_MINS  = /(?<minutes>\d+)m/

  REG_SECS  = /(?<minutes>\d+)s/  

  REG_TASK   = /(\s+(?<task>.*))/
  
  REG_TIME  = /\d{1,2}:\d{1,2}(:\d{1,2})?/

  # Example: 2h 30m working on stuff
  REG_SHORT  = /#{REG_HOURS}?\s*#{REG_MINS}?\s*#{REG_SECS}?#{REG_TASK}?/

  REG_DELIM = /\s*-\s*/

  # Example: 09:13:46 - 10:42:39 working on stuff
  REG_LONG  = /(?<in>#{REG_TIME})#{REG_DELIM}(?<out>#{REG_TIME})+#{REG_TASK}?/i


  def parse_entry( date, string, project:)
    if m = string.match(REG_LONG)
      hash = m.named_captures.merge('project' => project)
      Doors::Entry.new( date, hash)
    elsif m = string.match(REG_SHORT)
      Doors::Entry.new( date,
                        'duration' => string,
                        'project' => project,
                        'task' => m[:task]
                      )
    else
      fail "Wrong entry format: '#{string}'"
    end
  end

  private
    def create_entry(date, info)
      Doors::Entry.new(date, info.merge('project' => @project))
    end

    def to_month(val)
      m = DateTime.strptime(val.to_s, '%B').month
    rescue ArgumentError
      month = val.to_i
      fail "Invalid month" if month < 1 || month > 12
      month
    end

end
