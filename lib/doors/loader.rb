require_relative './path_helper'

class Doors::Loader

  include Doors::Logging
  include Doors::PathHelper

  def initialize(cli, project: :all)
    @cli = cli
    @root = cli.config.root
    @listeners = Listeners.new
    @filters   = Filters.new
    project = :all if project.blank?

    @projects = if project == :all
                  Dir["#{@root}/*"].map { |f|
                    File.basename(f) if File.directory?(f)
                  }.compact.freeze
                else
                  @project   = [ project ]
                end
  end

  def load_months!(*months)
    @entries = months.map do |month|
      entries = @projects.map do |project|
        file = path_for(project, month)
        info "Loading #{file} in #{project}"
        parser.load(file, project)
      end.flatten

      entries.each do |entry|
        add_entry(entry)
      end

    end.flatten.compact
  end

  def add_entry(entry)
    return unless entry

    if @filters.entry_allowed?(entry)
      debug "Loaded #{entry.inspect}"
      @listeners.entry_loaded(entry)
    else
      debug "Filtered #{entry.inspect}"
    end
    
  end

  def add_listeners(*listeners)
    @listeners << listeners
    @listeners.flatten!
    self
  end

  def add_filters(*filters)
    @filters << filters
    @filters.flatten!
    self
  end

  alias :add_listener :add_listeners
  alias :add_filter   :add_filters

  private
    def notify_listeners!(entries)
      entries.each do |e|
        @listeners.notify_all!(e)
      end
    end

    def parser
      @parser ||= Doors::Parser.new
    end

    class Listeners < Array
      def entry_loaded(entry)
        # TODO: rename #insert to #entry_loaded
        each { |listener| listener.insert(entry) }
      end
    end

    class Filters < Array
      def entry_allowed?(entry)
        all? { |filter| filter.entry_allowed?(entry) }
      end
    end

end
