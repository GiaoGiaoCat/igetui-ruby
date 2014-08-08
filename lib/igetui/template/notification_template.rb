module IGeTui
  class NotificationTemplate < BaseTemplate
    attr_accessor :title, :text, :logo, :logo_url
    attr_accessor :is_ring, :is_vibrate, :is_clearable

    def initialize
      @title = ''
      @text = ''
      @logo = ''
      @logo_url = ''
      @transmission_type = 0
      @transmission_content = ''
      @is_ring = true
      @is_vibrate = true
      @is_clearable = false
      super
    end

    def get_action_chain
      # set actionchain
      actionChain1 = GtReq::ActionChain.new
      actionChain1.actionId = 1
      actionChain1.type = GtReq::ActionChain::Type::Goto
      actionChain1.next = 10000

      # notification
      actionChain2 = GtReq::ActionChain.new
      actionChain2.actionId = 10000
      actionChain2.type = GtReq::ActionChain::Type::Notification
      actionChain2.title = title
      actionChain2.text = text
      actionChain2.logo = logo
      actionChain2.logoURL = logo_url
      actionChain2.ring = is_ring
      actionChain2.clearable = is_clearable
      actionChain2.buzz = is_vibrate
      actionChain2.next = 10010

      # goto
      actionChain3 = GtReq::ActionChain.new
      actionChain3.actionId = 10010
      actionChain3.type = GtReq::ActionChain::Type::Goto
      actionChain3.next = 10030

      # appStartUp
      appStartUp = GtReq::AppStartUp.new(android: '', symbia: '', ios: '')

      # start web
      actionChain4 = GtReq::ActionChain.new
      actionChain4.actionId = 10030
      actionChain4.type = GtReq::ActionChain::Type::Startapp
      actionChain4.appid = ''
      actionChain4.autostart = @transmission_type == 1
      actionChain4.appstartupid = appStartUp
      actionChain4.failedAction = 100
      actionChain4.next = 100

      # end
      actionChain5 = GtReq::ActionChain.new
      actionChain5.actionId = 100
      actionChain5.type = GtReq::ActionChain::Type::Eoa

      [actionChain1, actionChain2, actionChain3, actionChain4, actionChain5]
    end

    def get_push_type
      "NotifyMsg"
    end
  end
end
