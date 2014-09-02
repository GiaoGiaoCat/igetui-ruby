module IGeTui
  # PushInfo support Apple Push Notification
  class PushInfo < GtReq::PushInfo
    STRING_ATTRIBUTES = %i(
      action_loc_key badge message sound
      action_key payload loc_key loc_args launch_image
    ).freeze

    attr_accessor *STRING_ATTRIBUTES

    def initialize
      STRING_ATTRIBUTES.each { |attr| instance_variable_set("@#{attr}", '') }
    end

    def update_properties(args)
      args.each { |k, v| instance_variable_set("@#{k}", v) }
      @actionLocKey = action_loc_key
      @locKey = loc_key
      @locArgs = loc_args
      @launchImage = launch_image
      @actionKey = action_key
    end

    # alias_method :actionLocKey, :action_loc_key
    # alias_method :locKey, :loc_key
    # alias_method :locArgs, :loc_args
    # alias_method :launchImage, :launch_image
    # alias_method :actionKey, :action_key
  end
end
