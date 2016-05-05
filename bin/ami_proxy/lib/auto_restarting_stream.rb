# A bit of a hack to ensure "run" gets called automatically when the
# AMI Stream actor is respawned by its supervisor.
module AmiProxy
  class AutoRestartingStream < RubyAMI::Stream
    def initialize(*args)
      @logged_in = false
      super(*args)
      async.run
    end

    def ready?
      @socket and !@socket.closed? and @logged_in
    end

    def run
      Timeout::timeout(@timeout) do
        @socket = TCPSocket.from_ruby_socket ::TCPSocket.new(@host, @port)
      end
      post_init
      # Oddly, putting this in login() or post_init() doesn't work!
      @logged_in = true if @username and @password
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
  end
end
