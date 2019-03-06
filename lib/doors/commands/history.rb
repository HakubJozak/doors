class Doors::Commands::History

  def initialize(cli, today = Date.today)
    @cli = cli
    @today = today
    @entries = {}
  end

  def call
    @total = 0
    loader.register!(self)
    loader.load_months!(*last_year)

    puts "Summary of #{project}"
    puts "-------------------------------"

    last_year.each do |date|
      key   = key_from_date(date)
      value = @entries[key] || '-'

      puts " %14s | %10s" % [ key, value ]
    end

    puts "-------------------------------"    
    puts " %14s | %10s" % [ 'TOTAL', @total ]

  end

  def insert(entry)
    return unless entry.project == project

    key = key_from_date(entry.date)
    @entries[key] ||= 0
    @entries[key] += entry.duration

    @total += entry.duration
  end

  private
    def key_from_date(date)
      date.strftime("%B %Y")
    end

    def project
      'inex'
    end

    def loader
      @loader ||= Doors::Loader.new(@cli)
    end

    def last_year
      @dates ||= 12.times.map { |i| @today << i }.reverse
    end

end
