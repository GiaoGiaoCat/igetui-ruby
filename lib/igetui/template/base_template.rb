module IGeTui
  class BaseTemplate
    attr_accessor :transmission_type, :transmission_content, :push_info

    def initialize
      @transmission_type = 0
      @transmission_content = ''
      @push_info = PushInfo.new
    end

    def get_transparent(pusher)
      transparent = GtReq::Transparent.new
      transparent.id = ''
      transparent.messageId = ''
      transparent.taskId = ''
      transparent.action = 'pushmessage'
      transparent.actionChain = get_action_chain
      transparent.pushInfo = push_info
      transparent.appId = pusher.app_id
      transparent.appKey = pusher.app_key
      transparent
    end

    def get_action_chain
      raise NotImplementedError, 'Must be implemented by subtypes.'
    end

    def get_push_type
      raise NotImplementedError, 'Must be implemented by subtypes.'
    end

    # NOTE:
    # iOS Pusher need the top four fields of 'push_info' are required.
    # options can be includes [:payload, :loc_key, :loc_args, :launch_image]
    # http://docs.igetui.com/pages/viewpage.action?pageId=590588
    def set_push_info(action_loc_key, badge, message, sound, options = {})
      args = options.merge({
        action_loc_key: action_loc_key,
        badge: badge,
        message: message,
        sound: sound
      })
      @push_info.update_properties(args)
      # validate method need refactoring.
      Validate.new.validate(args)
      @push_info
    end

  end
end
