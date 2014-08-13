# IGeTui::Ruby

[个推](http://www.igetui.com/)服务端 ruby-sdk

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'igetui-ruby', require: 'igetui'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install igetui-ruby
```

## Usage

### Push Message To Single

```ruby
pusher = IGeTui.pusher(your_app_id, your_app_key, your_master_secret)

# 创建通知模板
template = IGeTui::NotificationTemplate.new
template.logo = 'push.png'
template.logo_url = 'http://www.igetui.com/wp-content/uploads/2013/08/logo_getui1.png'
template.title = '测试标题'
template.text = '测试文本'

# 创建单体消息
single_message = IGeTui::SingleMessage.new
single_message.data = template

# 创建客户端对象
client = IGeTui::Client.new(your_client_id)

# 发送一条通知到指定的客户端
ret = pusher.push_message_to_single(single_message, client)
p ret
```

### Push Message To List

```ruby
pusher = IGeTui.pusher(your_app_id, your_app_key, your_master_secret)

# 创建一条透传消息
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

# 创建群发消息
list_message = IGeTui::ListMessage.new
list_message.data = template

# 创建客户端对象
client_1 = IGeTui::Client.new(your_client_id_1)
client_2 = IGeTui::Client.new(your_client_id_2)
client_list = [client_1, client_2]

content_id = pusher.get_content_id(list_message)
ret = pusher.push_message_to_list(content_id, client_list)
```

### Push Message To App

```ruby
pusher = IGeTui.pusher(your_app_id, your_app_key, your_master_secret)

# 创建通知模板
template = IGeTui::NotificationTemplate.new
template.logo = 'push.png'
template.logo_url = 'http://www.igetui.com/wp-content/uploads/2013/08/logo_getui1.png'
template.title = '测试标题'
template.text = '测试文本'

# 创建APP群发消息
app_message = IGeTui::AppMessage.new
app_message.data = template
app_message.app_id_list = [your_app_id]

# 发送一条通知到程序
ret = pusher.push_message_to_app(app_message)
p ret
```

### Custom Test

```ruby
require 'rubygems'
require 'igetui'

@pusher = IGeTui.pusher(your_app_id, your_app_key, your_master_secret)
ret = @pusher.get_client_id_status(@cid_1)
p ret
```

### Auto Test

运行测试之前，请先修改 test/pusher_test.rb 中的相关配置。

```ruby
rake test
```

## Documents

* [参数说明](https://github.com/wjp2013/igetui-ruby/wiki/%E5%8F%82%E6%95%B0%E8%AF%B4%E6%98%8E)
* [模板类型说明](https://github.com/wjp2013/igetui-ruby/wiki/%E6%A8%A1%E6%9D%BF%E7%B1%BB%E5%9E%8B%E8%AF%B4%E6%98%8E)

## Contributing

1. Fork it ( http://github.com/<my-github-username>/igetui-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
