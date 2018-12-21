class Doors::Commands::Print

  attr_reader :month

  def initialize(argv, store, tracker)
    @store = store
    @tracker = tracker
    parse_month!(argv.first)
  end

  def run!
    puts printer.summary(month)
    puts "        %28s %s" % [ '', @tracker.status ]
    puts "   " + "~" * 60
  end
  
  private
    def parse_month!(value)
      @month = case value
               when /^\d+$/
                 Date.new(today.year, m.to_i, 1)
               when /l(ast)?/i
                 today << 1
               else
                 today
               end
    end

    def today
      @today ||= Date.today
    end    

    def printer
      @printer ||= Doors::Printer.new(@store)
    end

  
end
