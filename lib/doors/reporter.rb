class Doors::Reporter

  attr_reader :sums

  def initialize(cli)
    @cli = cli
    @root = cli.config.root
    load_entries!
  end

  def entries
    @filter ||= Doors::EntriesFilter.new(@entries)
  end

  #private
    def load_entries!
      @sums = {}
      this_month = Date.today
      last_month = this_month << 1

      @entries = [ last_month, this_month ].map do |month|
        entries = projects.map do |project|
          file = path_for(project, month)
          parser.load(file, project)
        end.flatten

        @sums[month] = Doors::Summary.new(entries)
        entries
      end.flatten.compact
    end

    # Example:
    #
    #  ~/time/kdm/october_2018.yml
    #
    def path_for(project, d = Date.today)
      month = d.strftime("#{@root}/#{project}/%Y_%B.yml").downcase
    end

    def projects
      @projects ||= Dir["#{@root}/*"].map { |f|
        File.basename(f) if File.directory?(f)
      }.compact.freeze
    end

    def parser
      @parser ||= Doors::Parser.new
    end


  
end
