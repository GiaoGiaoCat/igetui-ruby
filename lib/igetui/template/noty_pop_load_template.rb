module IGeTui
  class NotyPopLoadTemplate < BaseTemplate
    attr_accessor :title, :text, :logo, :logo_url
    attr_accessor :is_ring, :is_vibrate, :is_clearable
    attr_accessor :pop_title, :pop_text, :pop_image
    attr_accessor :pop_button_1, :pop_button_2
    attr_accessor :load_icon, :load_title, :load_url
    attr_accessor :android_mask, :symbia_mask, :ios_mask
    attr_accessor :is_auto_install, :is_active

    def initialize
      @title = ''
      @text = ''
      @logo = ''
      @logo_url = ''
      @pop_title = ''
      @pop_text = ''
      @pop_image = ''
      @pop_button_1 = ''
      @pop_button_2 = ''
      @load_icon = ''
      @load_title = ''
      @load_url = ''
      @transmission_type = 0
      @transmission_content = ''
      @is_ring = true
      @is_vibrate = true
      @is_clearable = true
      @android_mask = ''
      @symbia_mask = ''
      @ios_mask = ''
      @is_auto_install = false
      @is_active = false
      super
    end

    def get_action_chain
      # set actionchain
      action_chain_1 = GtReq::ActionChain.new
      action_chain_1.actionId = 1
      action_chain_1.type = GtReq::ActionChain::Type::Goto
      action_chain_1.next = 10000

      # notification
      action_chain_2 = GtReq::ActionChain.new
      action_chain_2.actionId = 10000
      action_chain_2.type = GtReq::ActionChain::Type::Notification
      action_chain_2.title = title
      action_chain_2.text = text
      action_chain_2.logo = logo
      action_chain_2.logoURL = logo_url
      action_chain_2.ring = is_ring
      action_chain_2.clearable = is_clearable
      action_chain_2.buzz = is_vibrate
      action_chain_2.next = 10010

      # goto
      action_chain_3 = GtReq::ActionChain.new
      action_chain_3.actionId = 10010
      action_chain_3.type = GtReq::ActionChain::Type::Goto
      action_chain_3.next = 10020

      action_chain_4 = GtReq::ActionChain.new

      button_1 = GtReq::Button.new
      button_1.text = pop_button_1
      button_1.next = 10040
      button_2 = GtReq::Button.new
      button_2.text = pop_button_2
      button_2.next = 100

      action_chain_4.actionId = 10020
      action_chain_4.type = GtReq::ActionChain::Type::Popup
      action_chain_4.title = pop_title
      action_chain_4.text = pop_text
      action_chain_4.img = pop_image
      action_chain_4.buttons = [button_1, button_2]
      action_chain_4.next = 6

      app_start_up = GtReq::AppStartUp.new(android: '', symbia: '', ios: '')
      action_chain_5 = GtReq::ActionChain.new
      action_chain_5.actionId = 10040
      action_chain_5.type = GtReq::ActionChain::Type::Appdownload
      action_chain_5.name = load_title
      action_chain_5.url = load_url
      action_chain_5.logo = load_icon
      action_chain_5.autoInstall = is_auto_install
      action_chain_5.autostart = is_active
      action_chain_5.appstartupid = app_start_up
      action_chain_5.next = 6

      # end
      action_chain_6 = GtReq::ActionChain.new
      action_chain_6.actionId = 100
      action_chain_6.type = GtReq::ActionChain::Type::Eoa

      [action_chain_1, action_chain_2, action_chain_3, action_chain_4, action_chain_5, action_chain_6]
    end

    def get_push_type
      "NotyPopLoadMsg"
    end
  end
end
