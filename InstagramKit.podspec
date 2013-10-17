
Pod::Spec.new do |s|
  s.name         = "InstagramKit"
  s.version      = "0.0.1"
  s.summary      = "An blocks-based Objective C wrapper for the Instagram API."

  s.description  = <<-DESC
A neat little blocks-based Objective C wrapper for the Instagram API.

*It readily parses the JSON responses on a background thread and does the dirty work for you so you just have to deal with Instagram model objects. 
*Harnesses the power of AFNetworking under the hood.
                  DESC

  s.homepage     = "http://github.com/shyambhat/InstagramKit"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Shyam Bhat" => "shyambhat@me.com" }
    s.platform     = :ios, '5.0'
  s.source       = { :git => "http://github.com/shyambhat/InstagramKit.git", :tag => "0.0.1" }
  s.source_files  = 'InstagramKit', 'InstagramKit/**/*.{h,m}'
  s.exclude_files = 'InstagramKitDemo/'
  s.requires_arc = true
end
