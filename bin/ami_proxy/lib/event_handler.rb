module AmiProxy
  class EventHandler
    class << self
      # Define an event handler
      def on(name, &handler)
        AmiProxy::Asterisk.register_event_handler(name, &handler)
      end
    end
  end
end
