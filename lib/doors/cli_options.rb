class Doors::CLIOptions
  def initialize(args)
    @opts = if args.empty?
              {}
            else
              parse!(args)
            end
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
