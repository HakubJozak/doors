class Doors::Store

  def initialize(root)
    @root = root
  end

  def add(entry)
    entries << entry unless entry.nil?
  end

  def save!
    by_months.each do |tag, month_entries|
      

    #   # TODO: pick the right file
    #   File.open("#{@root}/#{file}.yml","w") { |f|
    #     f.write(serialized.to_yaml)
    #   }
    end
  end

  def to_hash
    out = {}

    entries.each do |entry|
      date = entry.date
      day   = date.strftime('%d_%A').downcase
      month = date.strftime('%B').downcase
      year  = date.year

      y = out[year] ||= {}
      m = y[month]  ||= {}
      d = m[day]    ||= []

      d << serialize_entry(entry)
    end

    out
  end


  # def serialize
  #   days = {}

  #   entries.group_by(&:date).each do |day, es|
  #     key = day.strftime('%d_%A').downcase
  #     days[key] = es.map { |e| serialize_entry(e) }
  #   end

  #   d = entries.first.date
  #   month = d.strftime('%B').downcase
  #   serialized = { d.year.to_i => { month => days }}
  # end

  def by_months
    entries.group_by { |entry,_|
      entry.date.strftime('%Y_%B').downcase
    }
  end

  def entries
    @entries ||= load!
  end

  private

    def load!
      entries = []

      Dir["#{@root}/*.yml"].each do |f|
        # puts "Loading #{f}"
        entries << parser.load(f)
      end

      entries.flatten!
    end

    def parser
      @parser ||= Doors::Parser.new
    end

    def serialize_entry(e)
      f = '%H:%M:%S'

      if e.in && e.out
        [ e.in.strftime(f), e.out.strftime(f) ].join(' - ')
      elsif e.out
        { 'out' => e.out.strftime(f) }
      elsif e.in
        { 'in'  => e.in.strftime(f) }
      elsif e.duration
        { 'duration' => e.duration.to_s }
      end
    end

    # def generate_id
    #   SecureRandom.hex(3)
    # end

    # Example:
    #
    #  ~/time/october_2018.yml
    #
    def path(d = Date.today)
      month = d.strftime('%B').downcase
      "#{dir}/#{d.year}_#{month}.yml"
    end



end
