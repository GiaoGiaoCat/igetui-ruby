module IGeTui
  class Validate
    def validate(args = {})
      # payload_map = get_payload(args)

      # json = JSON.generate payload_map
      # if (json.length > 256)
      #   raise ArgumentError.new("PushInfo length over limit: #{json.length}. Allowed: 256.")
      # end

      is_validate = validate_payload(args)
      unless is_validate
        payload_len = validate_payload_length(args)
        raise ArgumentError.new("PushInfo length over limit: #{payload_len.length}. Allowed: 256.")
      end
    end

    def validate_payload(args)
      length = validate_payload_length(args)
      length <= 256
    end

    def validate_payload_length(args)
      json = process_payload(args)
      json.length
    end

    def process_payload(args)
      is_valid = false
      pb = Payload.new
      if !args[:loc_key].nil? && args[:loc_key].length > 0
        pb.alert_loc_key = args[:loc_key]
        if !args[:loc_args].nil? && args[:loc_args].length > 0
          pb.alert_loc_args = args[:loc_args].split(",")
        end
        is_valid = true
      end

      if !args[:message].nil? && args[:message].length > 0
        pb.alert_body = args[:message]
        is_valid = true
      end

      if !args[:action_loc_key].nil? && args[:action_loc_key].length > 0
        pb.alert_action_loc_key = args[:action_loc_key]
      end

      if !args[:launch_image].nil? && args[:launch_image].length > 0
        pb.alert_launch_image = args[:launch_image]
      end

      badge_num = args[:badge].to_i

      if badge_num >= 0
        pb.badge = badge_num
        is_valid = true
      end

      if !args[:sound].nil? && args[:sound].length > 0
        pb.sound = args[:sound]
      end

      if !args[:payload].nil? && args[:payload].length > 0
        pb.add_param("payload", payload)
      end

      unless is_valid
        puts "one of the params(locKey,message,badge) must not be null"
      end

      json = pb.to_s

      if json.nil?
        puts "payload json is null"
      end

      json

      # do something
    end

    def get_payload(args = {})
      apnsMap = Hash.new

      sound = "default" unless validate_length(args, :sound)
      apnsMap["sound"] = args[:sound]

      alertMap = Hash.new
      if validate_length(args, :launch_image)
        alertMap["launch-image"] = args[:launch_image]
      end

      if validate_length(args, :loc_key)
        alertMap["loc-key"] = args[:loc_key]
        if validate_length(args, :loc_args)
          alertMap["loc-args"] = args[:loc_args].split(", ")
        end
      elsif validate_length(nil, args[:message])
        alertMap["body"] = args[:message]
      end

      apnsMap["alert"] = alertMap
      if validate_length(args, :action_loc_key)
        apnsMap["action-loc-key"] = args[:action_loc_key]
      end

      apnsMap["badge"] = args[:badge]

      h = Hash.new
      h["aps"] = apnsMap
      h["payload"] = args[:payload] if validate_length(nil, args[:payload])

      return h
    end

    private

    def validate_length(args = {}, key)
      if key.class == Symbol
        args[key] && args[key].length > 0
      else
        key && key.length > 0
      end
    end
  end
end
