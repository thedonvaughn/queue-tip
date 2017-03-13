load File.join(File.dirname(__FILE__),'auto_restarting_stream.rb')

module AmiProxy
  class Asterisk
    class << self
      attr_accessor :servers
      servers = []

      def register_event_handler(e, &handler)
        @@handlers ||= {}
        @@handlers[e] ||= []
        @@handlers[e].push(handler)
      end

      # This is a bit weird but makes the API simpler
      def send_to_all_servers(name, headers={})
        @@instance.send_to_all_servers(name, headers)
      end
    end

    def initialize
      @@instance = self
    end

    def handle_event(e)
      handlers = @@handlers[e.name] || []
      handlers.each { |h| h.call(e) }
    end

    class AmiSuperVisionGroup < Celluloid::SupervisionGroup
      # Restart as usual, but after a timeout
      def restart_actor(actor, reason)
        sleep 5
        super actor, reason
      end
    end

    def send_to_all_servers(name, headers)
      @supervision_groups.map do |sv|
        begin
          actor = sv.actors.first
          if actor and actor.ready?
            actor.send_action(name, headers)
          end
        # Ignore these errors; just skip server until it comes back up
        rescue Celluloid::Task::TerminatedError
        rescue Celluloid::DeadActorError
        end
      end.compact
    end

    # Connect to all registered servers and start handling events
    def connect!
      @@handlers ||= {}
      @supervision_groups = []

      self.class.servers.each do |serv|
        Logging.logger.info("Registering Asterisk server #{serv[:host]} on port #{serv[:port]}")
        group = AmiSuperVisionGroup.new do |group|
          group.supervise(
            AmiProxy::AutoRestartingStream,
            serv[:host], serv[:port], serv[:username], serv[:password],
            Proc.new { |e| handle_event e }, Logging.logger,
            serv[:timeout] || 10
          )
        end
        @supervision_groups.push(group)
      end
    end
  end
end
