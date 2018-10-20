require 'yaml'
require 'ostruct'

class Doors::Config

  def initialize
    @vars = YAML.load_file(path)
  rescue Errno::ENOENT
    fail_and_exit "Missing config file '#{path}'"
  rescue Psych::SyntaxError
    fail_and_exit "Invalid config file"
  end

  def git
    if @vars.has_key?('git')
      OpenStruct.new(@vars['git'])
    else
      fail_and_exit("Missing 'git' section in #{path}")
    end
  end

  def path
    "#{ENV['HOME']}/.config/doors.yml"
  end

  def root
    path = @vars['root'] || "#{ENV['HOME']}/time"

    unless Dir.exist?(path)
      system "mkdir -p #{path}"
    end

    path
  end

  def fail_and_exit(msg)
    puts msg
    exit 1
  end

end
