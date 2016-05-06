# A bit of a hack to ensure "run" gets called automatically when the
# AMI Stream actor is respawned by its supervisor.
module AmiProxy
  class AutoRestartingStream < RubyAMI::Stream
    def initialize(*args)
      @fully_booted = false
      super(*args)
      async.run
    end

    def ready?
      @fully_booted and @socket and !@socket.closed?
    end

    def fire_event(event)
      @fully_booted = true if (event.name == 'FullyBooted')
      @event_callback.call event
    end

    def run
      Timeout::timeout(@timeout) do
        @socket = TCPSocket.from_ruby_socket ::TCPSocket.new(@host, @port)
      end
      post_init
      loop { receive_data @socket.readpartial(4096) }
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, SocketError => e
      logger.error "Connection failed due to #{e.class}. Check your config and the server."
      # Don't reconnect immediately
      raise e
    rescue EOFError
      logger.info "Client socket closed!"
      # Don't reconnect immediately
      raise e
    rescue Timeout::Error
      logger.error "Timeout exceeded while trying to connect."
      # Don't reconnect immediately
      raise e
    end

    # Apply a timeout for action sending/response retrieval as well:
    # if host is down we don't want to wait for it.  This will trigger
    # a timeout exception which crashes this agent, causing any caller
    # to unblock.
    def send_action(*args)
      Timeout::timeout(@timeout) { super(*args) }
    end
  end
end
