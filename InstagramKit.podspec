Pod::Spec.new do |s|
  s.name         = 'InstagramKit-afn2'
  s.version      = '0.1.0'
  s.summary      = 'Objective C Instagram Engine'
  s.description  = <<-DESC
  
* A neat little blocks-based Objective C wrapper for the Instagram API.
* It readily parses the JSON responses on a background thread and does the dirty work for you 
* so you just have to deal with Instagram model objects. 
* Harnesses the power of AFNetworking under the hood.

* This is based on a fork of Shaym Bhat's Instagram Kit.  It includes some
* minor feature enhancements and supports AFNetworking 2.0

                   DESC

  s.homepage     = 'https://github.com/ptwohig/InstagramKit'
  s.license      = 'MIT'
  s.author       = { "Patrick Twohig" => "invictvs@namazustudios.com" }
  s.platform     = :ios, '6.1'
  s.source       = { :git => "https://github.com/ptwohig/InstagramKit.git", :tag => "0.1.0" }
  s.source_files  = 'InstagramKit', 'InstagramKit/**/*.{h,m}'
  s.exclude_files = 'InstagramKitDemo'
  s.requires_arc = true
  s.dependency 'AFNetworking', '~> 2.0'

end

