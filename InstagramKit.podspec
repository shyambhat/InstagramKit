Pod::Spec.new do |s|
  s.name         = 'InstagramKit'
  s.version      = '3.6.5'
  s.summary      = 'Instagram iOS SDK.'
  s.description  = <<-DESC

* An extensive blocks-based Objective C wrapper for the Instagram API.
                   DESC

  s.homepage     = 'https://github.com/shyambhat/InstagramKit'
  s.license      = 'MIT'
  s.author       = { "Shyam Bhat" => "shyambhat@me.com" }
  s.platform     = :ios, '6.0'
  s.source       = { :git => "https://github.com/shyambhat/InstagramKit.git", :tag => '3.6.5' }
  s.source_files  = 'InstagramKit', 'InstagramKit/**/*.{h,m}'
  s.exclude_files = 'InstagramKitDemo'
  s.requires_arc = true
  s.dependency 'AFNetworking', '~>2.0'

end
