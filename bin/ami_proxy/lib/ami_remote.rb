require File.join(File.dirname(__FILE__), 'queue_status')

class AmiRemote
  # Simply create proxy methods for the high-level AMI methods

  def send_action(*args)
    Adhearsion::Asterisk.execute_ami_action(*args)
  end

  [:introduce, :originate, :call_into_context, :call_and_exec].each do |method_name|
    define_method(method_name) do |*args|
      #if VoIP::Asterisk.manager_interface
      Adhearsion::Asterisk.execute_ami_action(method_name, *args)
      #else
      #  logger.error "AMI has not been enabled!"
      #end
    end
  end

  # For the queue_status command, pull in the separate module
  include QueueStatus
end
