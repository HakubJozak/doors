class Doors::Reporter

  attr_reader :summaries, :details

  def initialize(cli)
    @cli = cli
    @root = cli.config.root
    create_summaries!
    load_entries!
  end

  # def entries
  #   @filter ||= Doors::EntriesFilter.new(@entries)
  # end

  #private
    def load_entries!
      this_month = Date.today
      last_month = this_month << 1

      @entries = [ last_month, this_month ].map do |month|
        entries = projects.map do |project|
          file = path_for(project, month)
          parser.load(file, project)
        end.flatten

        notify_listeners!(entries)
      end.flatten.compact
    end

    def create_summaries!
      today = Date.today
      yesterday = today - 1
      this_month = Date.today
      last_month = this_month << 1

      @summaries = []
      @summaries << Doors::Summary.new('Last month') { |entry|
        entry.in_month?(last_month)
      }

      @summaries << Doors::Summary.new('This month') { |entry|
        entry.in_month?(this_month)
      }

      @details = []
      @details << Doors::DaySummary.new(yesterday)
      @details << Doors::DaySummary.new(today)      
    end

    # Example:
    #
    #  ~/time/kdm/october_2018.yml
    #
    def path_for(project, d = Date.today)
      month = d.strftime("#{@root}/#{project}/%Y_%B.yml").downcase
    end

    def notify_listeners!(entries)
      @summaries.each { |s| s.update(entries) }
      @details.each { |s| s.update(entries) }      
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
