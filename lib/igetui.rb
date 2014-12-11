require 'forwardable'
require 'net/http'
require 'uri'
require 'json'
require 'digest/md5'
require 'base64'

module IGeTui
  class << self
    extend Forwardable

    API_URL = "http://sdk.open.api.igexin.com/apiex.htm"

    attr_reader :pusher

    def_delegators :pusher, :push_message_to_single
    def_delegators :pusher, :push_message_to_list
    def_delegators :pusher, :push_message_to_app
    def_delegators :pusher, :stop
    def_delegators :pusher, :get_client_id_status
    def_delegators :pusher, :get_content_id, :cancel_content_id

    def pusher(app_id, api_key, master_secret)
      IGeTui::Pusher.new(API_URL, app_id, api_key, master_secret)
    end

  end
end

require "igetui/version"
require 'protobuf/GtReq.pb'
require "igetui/template"
require "igetui/validate"
require "igetui/message"
require "igetui/pusher"
require "igetui/client"
