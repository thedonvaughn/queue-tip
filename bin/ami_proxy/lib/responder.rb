module AmiProxy
  class Responder
    class << self
      # Define a callback for an RPC call
      def on(name, &handler)
        AmiProxy::DRbServer.register_responder(name, &handler)
      end
    end
  end
end
