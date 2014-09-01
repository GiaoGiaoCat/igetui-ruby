module IGeTui
  class BaseTemplate
    attr_accessor :transmission_type, :transmission_content

    def initialize
      @transmission_type = 0
      @transmission_content = ''
      @push_info = GtReq::PushInfo.new
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

    def get_push_info
      @push_info.actionKey = ''
      @push_info.badge = ''
      @push_info.message = ''
      @push_info.sound = ''
      @push_info
    end

    # Need TEST:
    #   iOS Pusher need the top three fields of 'push_info' are required.
    #   the others can be blank string.
    def set_push_info(action_loc_key, badge, message, sound, payload, loc_key, loc_args, launch_image)
      @push_info.actionLocKey = action_loc_key
      @push_info.badge = badge
      @push_info.message = message
      @push_info.sound = sound if sound
      @push_info.payload = payload if payload
      @push_info.locKey = loc_key if loc_key
      @push_info.locArgs = loc_args if loc_args
      @push_info.launchImage = launch_image if launch_image

      args = {
        loc_key: loc_key,
        loc_args: locArgs,
        message: message,
        action_loc_key: action_loc_key,
        launch_image: launch_image,
        badge: badge,
        sound: sound,
        payload: payload
      }

      Validate.new.validate(args)
      @push_info
    end

  end
end
