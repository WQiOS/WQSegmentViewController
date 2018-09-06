
Pod::Spec.new do |s|

s.name         = "WQSegmentViewController"
s.version      = "0.0.1"
s.summary      = "视图切换的插件，以后渐渐完善她"
s.homepage     = "https://github.com/WQiOS/WQSegmentViewController"
s.license      = "MIT"
s.author       = { "wangqiang" => "1570375769@qq.com" }
s.platform     = :ios, "8.0" #平台及支持的最低版本
s.requires_arc = true # 是否启用ARC
s.source       = { :git => "https://github.com/WQiOS/WQSegmentViewController.git", :tag => "#{s.version}" }
s.ios.framework  = 'UIKit'
s.source_files  = "WQSegmentViewController/*.{h,m}"

end
