module IGeTui
  class TransmissionTemplate < BaseTemplate
    def initialize
      @transmission_type = 0
      @transmission_content = ''
      super
    end

    def get_action_chain
      # set actionChain
      actionChain1 = GtReq::ActionChain.new
      actionChain1.actionId = 1
      actionChain1.type = GtReq::ActionChain::Type::Goto
      actionChain1.next = 10030

      # appStartUp
      appStartUp = GtReq::AppStartUp.new(android: '', symbia: '', ios: '')

      # start up app
      actionChain2 = GtReq::ActionChain.new
      actionChain2.actionId = 10030
      actionChain2.type = GtReq::ActionChain::Type::Startapp
      actionChain2.appid = ''
      actionChain2.autostart = transmission_type == 1
      actionChain2.appstartupid = appStartUp
      actionChain2.failedAction = 100
      actionChain2.next = 100

      # end
      actionChain3 = GtReq::ActionChain.new
      actionChain3.actionId = 100
      actionChain3.type = GtReq::ActionChain::Type::Eoa

      [actionChain1, actionChain2, actionChain3]
    end

    def get_push_type
      "TransmissionMsg"
    end

  end
end
