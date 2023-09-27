#
# Be sure to run `pod lib lint WBAmityUIKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WBAmityUIKit'
  s.version          = '0.2.17'
  s.summary          = 'WBAmityUIKit is a form of AmityUIKit'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/AppSci/Amity-Social-Cloud-UIKit-iOS-OpenSource'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'LGPL', :file => 'UpstraUIKit/LICENSE' }
  s.author           = { 'Boosters' => 'roman.mishchenko@gen.tech' }
  s.source           = { :git => 'https://github.com/AppSci/Amity-Social-Cloud-UIKit-iOS-OpenSource.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '15.0'
  
  s.source_files = 'UpstraUIKit/UpstraUIKit/**/**.{h,hpp,m,swift,xib,storyboard,modulemap,plist,plist,xcconfig,strings}'
  s.resource = 'UpstraUIKit/UpstraUIKit/Assets.xcassets'

  s.dependency 'AmitySDK', '5.33.8'
  s.dependency 'RealmSwift'
  s.dependency 'NVActivityIndicatorView'
end
