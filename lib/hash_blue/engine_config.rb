#
# O2 Labs has exposed the power of #blue to developers via a simple REST & JSON based API, 
# enabling new ways for users to manage their texts and add combine the ubiquity of SMS 
# with their applications, users simply grant an application access to their messages stream 
# or just certain messages.
#
# Juan de Bravo (juandebravo@gmail.com)
# Ruby sensei at The Lab (http://thelab.o2.com)
#

module HashBlue
  # Array of elements that should be configured
  # By default, :uri endpoint is configured in the Engine. The rest of parameters are client specific
  hashblue_config = [:uri, :client_id, :client_secret, :forward_action]

  class EngineConfig  < Struct.new(*hashblue_config)
  end
end