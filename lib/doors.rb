require 'active_support/core_ext/object/blank'


module Doors
  class Error < RuntimeError ; end

  module Commands ; end
  module Formatters ; end
end


require_relative '../core_ext/date'

require_relative 'doors/logging'
require_relative 'doors/config'
require_relative 'doors/duration'
require_relative 'doors/time_ops'
require_relative 'doors/cli_colors'

require_relative 'doors/project_selector'
require_relative 'doors/tracker'
require_relative 'doors/parser'

require_relative 'doors/date_filter'
require_relative 'doors/cli'
require_relative 'doors/store'
require_relative 'doors/git'
require_relative 'doors/printer'
require_relative 'doors/loader'

require_relative 'doors/commands/print'
require_relative 'doors/commands/start'
require_relative 'doors/commands/i3'
require_relative 'doors/commands/log'

require_relative 'doors/formatters/log_formatter'
# require_relative 'doors/summary'
# require_relative 'doors/day_summary'

require_relative 'doors/reports/entry_sum'
require_relative 'doors/reports/total_report'
require_relative 'doors/reports/year_report'
require_relative 'doors/reports/month_report'
