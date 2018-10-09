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
      days[key] = es.map(&:to_hash)
    end

    puts({ '2018': { 'october' => days }})
  end

  def entries
    @entries ||= load!
  end

  private

    def load!
      entries = []
        
      Dir["#{@root}/*.yml"].each do |f|
        puts "Loading #{f}"
        entries << parser.load(f)
      end

      entries.flatten!      
    end

    def parser
      @parser ||= Doors::Parser.new
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
