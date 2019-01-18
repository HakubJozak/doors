class Doors::Store

  include Doors::Naming

  def initialize(cli)
    @cli = cli
    @project = cli.project
    @root = "#{cli.config.root}/#{project}"

    unless Dir.exist?(@root)
      system "mkdir -p #{@root}"
    end
  end

  def filter
    @filter ||= Doors::EntriesFilter.new(entries)
  end

  def add(entry)
    entries << entry unless entry.nil?
  end

  def save!
    to_hash.each do |year,months|
      months.each do |month,days|
        File.open( path_for(@project, year: year, month: month)) { |f|
          data = { year => { month => days }}
          f.write(data.to_yaml)
        }
      end
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

      entries.flatten
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

end
