module IGeTui
  class Message
    attr_accessor :is_offline, :offline_expire_time, :data

    def initialize
      @is_offline = true
      @offline_expire_time = 1000 * 3600 * 12
      @data = BaseTemplate.new
    end
  end

  SingleMessage = Class.new(Message)
  ListMessage = Class.new(Message)

  class AppMessage < Message
    attr_accessor :app_id_list, :phone_type_list, :province_list, :tag_list

    def initialize
      super
      @app_id_list = []
      @phone_type_list = []
      @province_list = []
      @tag_list = []
    end
  end
end
