#
# Be sure to run `pod lib lint ReactiveLevelCache.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ReactiveLevelCache'
  s.version          = '0.15.0'
  s.summary          = 'Objective-C level db with Reactive Cache compatible interface'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Google's LevelDB with RACSignal interface
                       DESC

  s.homepage         = 'https://github.com/haifengkao/ReactiveLevelCache'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Hai Feng Kao' => 'haifeng@cocoaspice.in' }
  s.source           = { :git => 'https://github.com/haifengkao/ReactiveLevelCache.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'ReactiveLevelCache/Classes/**/*'
  s.swift_version = '5.0' # AltHanekeSwift use 4.2
  
  # s.resource_bundles = {
  #   'ReactiveLevelCache' => ['ReactiveLevelCache/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'ReactiveCache', '>= 0.37.0' # swift 5
   s.dependency 'Objective-LevelDB'
   s.dependency 'leveldb-library', '>= 1.22'
   s.dependency 'ReactiveObjC'
end
