module IGeTui
  class Pusher
    attr_reader :host, :app_id, :app_key, :master_secret

    def initialize(host, app_id, app_key, master_secret)
      @host = host
      @app_id = app_id
      @app_key = app_key
      @master_secret = master_secret
    end

    def push_message_to_single(message, client)
      template = message.data
      data = {
        'action' => 'pushMessageToSingleAction',
        'appkey' => app_key,
        'clientData' => template.get_client_data(self),
        'transmissionContent' => template.transmission_content,
        'isOffline' => message.is_offline,
        'offlineExpireTime' => message.offline_expire_time,
        'appId' => app_id,
        'clientId' => client.client_id,
        'type' => 2, #default is message
        'pushType' => template.get_push_type
      }

      http_post_json(data)
    end

    def push_message_to_list(content_id, clients)
      target_list = clients.inject([]) do |list, cilent|
        list << { 'appId' => app_id, 'clientId' => cilent.client_id }
      end

      # seems that we miss 'pushType'
      data = {
        'action' => 'pushMessageToListAction',
        'appkey' => app_key,
        'contentId' => content_id,
        'needDetails' => true,
        'targetList' => target_list,
        'type' => 2
      }

      http_post_json(data)
    end

    def push_message_to_app(message)
      template = message.data
      data = {
        'action' => 'pushMessageToAppAction',
        'appkey' => app_key,
        'clientData' => template.get_client_data(self),
        'transmissionContent' => template.transmission_content,
        'isOffline' => message.is_offline,
        'offlineExpireTime' => message.offline_expire_time,
        'appIdList' => message.app_id_list,
        'phoneTypeList' => message.phone_type_list,
        'provinceList' => message.province_list,
        'tagList' => message.tag_list,
        'type' => 2,
        'pushType' => template.get_push_type
      }
      http_post_json(data)
    end

    def stop(content_id)
      data = {
        'action' => 'stopTaskAction',
        'appkey' => @appKey,
        'contentId' => content_id
      }

      ret = http_post_json(data)
      ret['result'] == 'ok'
    end

    def get_client_id_status(client_id)
      data = {
        'action' => 'getClientIdStatusAction',
        'appkey' => app_key,
        'appId' => app_id,
        'clientId' => client_id
      }
      http_post_json(data)
    end


    def get_content_id(message)
      template = message.data
      data = {
        'action' => 'getContentIdAction',
        'appkey' => app_key,
        'clientData' => template.get_client_data(self),
        'transmissionContent' => template.transmission_content,
        'isOffline' => message.is_offline,
        'offlineExpireTime' => message.offline_expire_time,
        'pushType' => template.get_push_type
      }
      ret = http_post_json(data)
      ret['result'] == 'ok' ? ret['contentId'] : ''
    end

    def cancel_content_id(content_id)
      data = {
        'action' => 'cancleContentIdAction',
        'contentId' => content_id,
      }
      ret = http_post_json(data)
      ret['result'] == 'ok'
    end


    private

    def connect
      time_stamp = Time.now.to_i
      sign = Digest::MD5.hexdigest(app_key + time_stamp.to_s + master_secret)
      data = {
        action: 'connect',
        appkey: app_key,
        timeStamp: time_stamp,
        sign: sign
      }
      ret = http_post(data)
      ret['result'] == 'success'
    end

    def http_post_json(params)
      params['version'] = '3.0.0.0'
      ret = http_post(params)

      if ret && ret['result'] == 'sign_error'
        connect
        ret = http_post(params)
      end
      ret
    end

    def http_post(params)
      params['version'] = '3.0.0.0'
      data = params.to_json

      url = URI.parse(host)
      req = Net::HTTP::Post.new(url.path, initheader = { 'Content-Type' => 'application/json' })
      req.body = data

      try_time = 0
      begin
        res = Net::HTTP.new(url.host, url.port).start { |http| http.request(req) }
      rescue => e
        try_time += 1
        if try_time >= 3 
          raise e
        else
          retry
        end
      end

      JSON.parse res.body
    end
  end
end
