# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'igetui/version'

Gem::Specification.new do |spec|
  spec.name          = "igetui-ruby"
  spec.version       = IGeTui::VERSION
  spec.authors       = ["Victor Wang"]
  spec.email         = ["QQ: 22674812"]
  spec.summary       = "igetui.com ruby sdk"
  spec.description   = "ruby-sdk of igetui.com push notification service"
  spec.homepage      = "https://github.com/wjp2013/igetui-ruby"
  spec.license       = "MIT"
  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.extra_rdoc_files = ["README.md"]

  spec.add_dependency "json", '~> 1.8', ">= 1.8.1"
  spec.add_dependency "ruby-protocol-buffers", '~> 1.5', '>= 1.5.1'

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake", '~> 10.3', '>= 10.3.1'
  spec.add_development_dependency "minitest", '~> 5.4', '>= 5.4.0'
end
