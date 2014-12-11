module IGeTui
  class BaseTemplate
    attr_accessor :transmission_type, :transmission_content, :push_info

    def initialize
      @transmission_type = 0
      @transmission_content = ''
    end

    def get_transparent(pusher)
      transparent = GtReq::Transparent.new
      transparent.id = ''
      transparent.messageId = ''
      transparent.taskId = ''
      transparent.action = 'pushmessage'
      transparent.actionChain = get_action_chain
      transparent.pushInfo = get_push_info
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

    def get_client_data(pusher)
      string = self.get_transparent(pusher).serialize_to_string
      Base64.strict_encode64 string
    end

    def get_push_info
      @push_info || init_push_info
    end

    # NOTE:
    # iOS Pusher need the top four fields of 'push_info' are required.
    # options can be includes [:payload, :loc_key, :loc_args, :launch_image]
    # http://docs.igetui.com/pages/viewpage.action?pageId=590588
    def set_push_info(action_loc_key, badge, message, sound, options = {})
      init_push_info
      @push_info.actionLocKey = action_loc_key
      @push_info.badge = badge.to_s
      @push_info.message = message
      @push_info.sound = sound
      @push_info.payload = options[:payload]
      @push_info.locKey = options[:loc_key]
      @push_info.locArgs = options[:loc_args]
      @push_info.launchImage = options[:launch_image]
      # validate method need refactoring.
      # Validate.new.validate(args)
    end

    private

    def init_push_info
      @push_info = GtReq::PushInfo.new
      @push_info.message = ''
      @push_info.actionKey = ''
      @push_info.sound = ''
      @push_info.badge = '-1'
      @push_info
    end

  end
end
