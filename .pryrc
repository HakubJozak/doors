require_relative 'lib/doors'

cli = Doors::CLI.new
git = Doors::Git.new(cli)
