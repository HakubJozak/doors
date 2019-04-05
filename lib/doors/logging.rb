module Doors::Logging
  private
    def debug(msg)
      if $log_level.to_i >= 5
        logging_stream.puts "%7s - %s" % [ 'DEBUG', msg.blue ]
      end
    end

    def logging_stream
      $stderr
    end
end
