class Doors::Store

  def initialize(root)
    @root = root
  end

  def add(entry)
    entries << entry unless entry.nil?
  end

  def save!
    # TODO: group by year and month
    days = {}

    entries.group_by(&:date).each do |day, es|
      key = day.strftime('%d_%A').downcase
      days[key] = es.map { |e| serialize_entry(e) }
    end

    serialized = { 2018 => { 'october' => days }}    

    # TODO: pick the right file
    File.open("#{@root}/2018_october.yml","w") { |f|
      f.write(serialized.to_yaml)
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
