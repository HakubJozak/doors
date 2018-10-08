require 'date'
require 'yaml'

require_relative 'entry'


class Doors::Tracker

  attr_reader :entries

  def initialize
    ensure_dir_exists!
    parser = Doors::Parser.new
    @entries = parser.load!(path) || []
  end

  def start!
  end

  def stop!
  end

  private

    def generate_id
      SecureRandom.hex(3)    
    end

    def save!
      ensure_dir_exists!      
    end

    # Example:
    #   
    #  ~/time/october_2018.yml
    # 
    def path(d = Date.today)
      month = d.strftime('%B').downcase
      "#{dir}/#{d.year}_#{month}.yml"
    end

    def dir
      "#{ENV['HOME']}/time"
    end

    def ensure_dir_exists!
      system "mkdir -p #{dir}"
    end
    
  
end
