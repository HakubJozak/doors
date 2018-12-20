class Doors::CLIOptions
  def initialize(args)
    @args = args.dup
    parse extract_commands!
  end

  def month
    case m = @opts[:month]
    when /^\d+$/
      Date.new(today.year, m.to_i, 1)
    when /l(ast)?/i
      Date.today << 1
    else
      Date.today
    end
  end

  private
    def extract_commands!
      # TOOD: there must be a better regexp way 
      @commands = []
      @args.gsub(/ [a-z]+|^[a-z]+/) { |s|
        @commands << s ; ''
      }
    end
  
    def today
      Date.today
    end

    def parse!(args)
      require 'slop'
      Slop.parse(args) do |o|
        o.string '-m','--month'
      end                  
    end


end
