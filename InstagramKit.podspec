
Pod::Spec.new do |s|
  s.name             = 'InstagramKit'
  s.version          = '4.1'
  s.summary          = 'Instagram iOS SDK.'
  s.description      = <<-DESC
An extensive Objective C SDK for the Instagram API.
                       DESC

  s.homepage         = 'https://github.com/shyambhat/InstagramKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Shyam Bhat' => 'shyambhat@me.com' }
  s.source           = { :git => 'https://github.com/shyambhat/InstagramKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.source_files = 'InstagramKit/Classes/**/*'
  s.dependency 'AFNetworking', '~>3.0'
  s.default_subspec = 'InstagramKit-without-UICKeyChainStore'
  
  s.subspec 'InstagramKit-without-UICKeyChainStore' do |exclude_uickeychainstore|
      # default lean subspec for users who don't need UICKeyChainStore
  end
  
  s.subspec 'UICKeyChainStore' do |uickeychainstore|
      uickeychainstore.xcconfig    =
      { 'OTHER_CFLAGS' => '$(inherited) -INSTAGRAMKIT_INCLUDE_UICKEYCHAINSTORE' }
      uickeychainstore.dependency 'UICKeyChainStore', '~>2.0'
  end
  
  # s.resource_bundles = {
  #   'InstagramKit' => ['InstagramKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  
  # To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html

end
