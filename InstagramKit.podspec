Pod::Spec.new do |s|
  s.name         = 'InstagramKit'
  s.version      = '3.8'
  s.summary      = 'Instagram iOS SDK.'
  s.description  = <<-DESC

* An extensive blocks-based Objective C wrapper for the Instagram API.
                   DESC

  s.homepage     = 'https://github.com/shyambhat/InstagramKit'
  s.license      = 'MIT'
  s.author       = { "Shyam Bhat" => "shyambhat@me.com" }
  s.platform     = :ios, '7.0'
  s.source       = { :git => "https://github.com/shyambhat/InstagramKit.git", :tag => s.version }
  s.source_files  = 'InstagramKit', 'InstagramKit/**/*.{h,m}'
  s.exclude_files = 'InstagramKitDemo'
  s.requires_arc = true
  s.dependency 'AFNetworking', '~>3.0'
  s.default_subspec = 'Exclude-UICKeyChainStore'

  s.subspec 'Exclude-UICKeyChainStore' do |exclude_uickeychainstore|
  # default lean subspec for users who don't need UICKeyChainStore
  end

  s.subspec 'UICKeyChainStore' do |uickeychainstore|
    uickeychainstore.xcconfig	=
        { 'OTHER_CFLAGS' => '$(inherited) -INSTAGRAMKIT_INCLUDE_UICKEYCHAINSTORE' }
    uickeychainstore.dependency 'UICKeyChainStore', '~>2.0'
  end
end
