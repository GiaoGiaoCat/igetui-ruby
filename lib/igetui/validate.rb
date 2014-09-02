require 'json'
module IGeTui
  class Validate
    def validate(args = {})
      payload_map = get_payload(args)

      json = JSON.generate payload_map
      if (json.length > 256)
        raise ArgumentError.new("PushInfo length over limit: #{json.length}. Allowed: 256.")
      end
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
