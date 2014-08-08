require 'minitest/autorun'
require './lib/igetui'

class PusherTest < MiniTest::Unit::TestCase

  # before run test, you need to change the variables in setup method.
  def setup
    @app_id = 'YOUR APP ID'
    @app_key = 'YOUR APP KEY'
    @master_secret = 'YOUR MASTER SECRET'
    @cid_1 = 'CLIENT ID ONE'
    @cid_2 = 'CLIENT ID TWO'

    @pusher = IGeTui.pusher(@app_id, @app_key, @master_secret)
    @client_1 = IGeTui::Client.new(@cid_1)
    @client_2 = IGeTui::Client.new(@cid_2)
  end

  def test_status
    ret = @pusher.get_client_id_status(@cid_1)
    assert_equal ret["result"], "Online"
  end

  def test_to_single_notification
    single_message = IGeTui::SingleMessage.new
    single_message.data = notification_template
    ret = @pusher.push_message_to_single(single_message, @client_1)
    assert_equal ret["result"], "ok"
  end

  def test_to_single_transmission
    single_message = IGeTui::SingleMessage.new
    single_message.data = transmission_template
    ret = @pusher.push_message_to_single(single_message, @client_1)
    assert_equal ret["result"], "ok"
  end

  def test_to_list_transmission
    list_message = IGeTui::ListMessage.new
    list_message.data = transmission_template
    client_list = [@client_1, @client_2]
    content_id = @pusher.get_content_id(list_message)
    ret = @pusher.push_message_to_list(content_id, client_list)
    assert_equal ret["result"], "ok"
  end

  def test_to_app_notification
    app_message = IGeTui::AppMessage.new
    app_message.data = notification_template
    app_message.app_id_list = [@app_id]
    # app_message.province_list = ['浙江', '上海']
    # app_message.tag_list = ['开心']
    ret = @pusher.push_message_to_app(app_message)
    assert_equal ret["result"], "ok"
  end

  private

  def notification_template
    template = IGeTui::NotificationTemplate.new
    template.logo = 'push.png'
    template.logo_url = 'http://www.igetui.com/wp-content/uploads/2013/08/logo_getui1.png'
    template.title = '测试标题'
    template.text = '测试文本'
    template
  end

  def transmission_template
    template = IGeTui::TransmissionTemplate.new
    # Notice: content should be string.
    content = {
                action: "notification",
                title: "标题aaa",
                content: "内容",
                type: "article",
                id: "4274"
              }
    content = content.to_s.gsub(":", "").gsub("=>", ":")
    template.transmission_content = content
    template
  end

end
