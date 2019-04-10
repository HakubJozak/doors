module Doors::Logging

  LEVELS = [ :error, :info, :debug ]

  private
    def info(msg)
      if LEVELS.index($log_level).to_i > 0
        logging_stream.puts "%7s - %s" % [ 'INFO', msg.green ]
      end
    end

    def debug(msg)
      if LEVELS.index($log_level).to_i > 1
        logging_stream.puts "%7s - %s" % [ 'DEBUG', msg.blue ]
      end
    end

    def logging_stream
      $stderr
    end
end
