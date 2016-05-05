module AmiProxy
  class DRbServer
    class << self
      attr_accessor :uri, :acl
      uri = 'druby://localhost:9050'
      acl = %w{allow localhost}

      def register_responder(name, &block)
        @@responders ||= {}
        if @@responders[name]
          raise "There's already a responder registered for the method '#{name}'"
        else
          @@responders[name] = true
          define_method(name, &block)
        end
      end

      def run!
        DRb.install_acl(ACL.new(self.acl, ACL::DENY_ALLOW))
        Logging.logger.info("Starting DRb server on #{self.uri}")
        DRb.start_service(self.uri, self.new)
        DRb.thread.join
      end
    end
  end
end
