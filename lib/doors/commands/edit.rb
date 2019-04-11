require_relative '../path_helper'

class Doors::Commands::Edit

  include Doors::PathHelper

  attr_reader :tracker

  def initialize(cli, today = Date.today)
    @cli = cli
    @root = cli.config.root
  end

  def call
    edit path_for(@cli.project)
  end

  

  private
    def edit(file)
      cmd = "#{editor} #{file} +#{line_count(file)}"
      puts cmd
      system(cmd)
    end

    def editor
      # ENV.fetch('EDITOR')
      'vim'
    end

    def line_count(file)
      system `cat #{file} | wc -l`.strip
    end
    
end
