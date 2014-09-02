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

  def test_to_single_noty_pop_load
    single_message = IGeTui::SingleMessage.new
    single_message.data = noty_pop_load_template
    ret = @pusher.push_message_to_single(single_message, @client_1)
    assert_equal ret["result"], "ok"
  end

  def test_to_single_notification
    single_message = IGeTui::SingleMessage.new
    single_message.data = notification_template
    ret = @pusher.push_message_to_single(single_message, @client_1)
    assert_equal ret["result"], "ok"
  end

  def test_to_single_link_notification
    single_message = IGeTui::SingleMessage.new
    single_message.data = link_template
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

  def set_template_base_info(template)
    template.logo = 'push.png'
    template.logo_url = 'http://www.igetui.com/wp-content/uploads/2013/08/logo_getui1.png'
    template.title = '测试标题'
    template.text = '测试文本'
  end

  def link_template
    template = IGeTui::LinkTemplate.new
    set_template_base_info(template)
    template.url = "http://www.baidu.com"
    template.set_push_info("open", 4, "message", "")
    template
  end

  def notification_template
    template = IGeTui::NotificationTemplate.new
    set_template_base_info(template)
    template.set_push_info("open", 4, "message", "")
    template
  end

  def transmission_template
    template = IGeTui::TransmissionTemplate.new
    # Notice: content should be string.
    content = {
                "action" => "notification",
                "title" => "标题aaa",
                "content" => "内容",
                "type" => "Article",
                "id" => "1234"
              }

    content = content.to_s.gsub(":", "").gsub("=>", ":")
    template.transmission_content = content
    puts template.transmission_content
    template.set_push_info("test", 1, "test1", "")
    template
  end

  # attr_accessor :load_icon, :load_title, :load_url
  def noty_pop_load_template
    template = IGeTui::NotyPopLoadTemplate.new
    set_template_base_info(template)
    template.pop_title = "弹框标题"
    template.pop_text = "弹框内容"
    template.pop_image = ""
    template.pop_button_1 = "下载"
    template.pop_button_2 = "取消"
    template.load_icon = "file://icon.png"
    template.load_title = "下载内容"
    template.load_url = "http://gdown.baidu.com/data/wisegame/c95836e06c224f51/weixinxinqing_5.apk"
    template
  end

end
