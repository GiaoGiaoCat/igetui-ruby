module IGeTui
  class TransmissionTemplate < BaseTemplate
    def initialize
      @transmission_type = 0
      @transmission_content = ''
      super
    end

    def get_action_chain
      # set actionChain
      action_chain_1 = GtReq::ActionChain.new
      action_chain_1.actionId = 1
      action_chain_1.type = GtReq::ActionChain::Type::Goto
      action_chain_1.next = 10030

      # appStartUp
      app_start_up = GtReq::AppStartUp.new(android: '', symbia: '', ios: '')

      # start up app
      action_chain_2 = GtReq::ActionChain.new
      action_chain_2.actionId = 10030
      action_chain_2.type = GtReq::ActionChain::Type::Startapp
      action_chain_2.appid = ''
      action_chain_2.autostart = transmission_type == 1
      action_chain_2.appstartupid = app_start_up
      action_chain_2.failedAction = 100
      action_chain_2.next = 100

      # end
      action_chain_3 = GtReq::ActionChain.new
      action_chain_3.actionId = 100
      action_chain_3.type = GtReq::ActionChain::Type::Eoa

      [action_chain_1, action_chain_2, action_chain_3]
    end

    def get_push_type
      "TransmissionMsg"
    end

  end
end
