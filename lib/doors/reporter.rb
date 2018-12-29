class Doors::Reporter

  attr_reader :entries

  def initialize(cli)
    @cli = cli
    @root = cli.config.root
    load_entries!
  end

  #private
    def load_entries!
      @entries = {}
      this_month = Date.today
      last_month = this_month << 1

      projects.each do |project|
        @entries[project] = [ last_month, this_month ].map do |month|
          file = path_for(project, month)
          parser.load(file)
        end.flatten.compact
      end
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
