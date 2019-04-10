module Doors::Logging

  LEVELS = [ :error, :info, :debug ]

  private
    def info(msg)
      if $log_level.to_i >= LEVELS.index(:info)
        logging_stream.puts "%7s - %s" % [ 'INFO', msg.green ]
      end
    end

    def debug(msg)
      if $log_level.to_i >= LEVELS.index(:debug)
        logging_stream.puts "%7s - %s" % [ 'DEBUG', msg.blue ]
      end
    end

    def logging_stream
      $stderr
    end
end
