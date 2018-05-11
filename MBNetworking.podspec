#
# Be sure to run `pod lib lint Networking.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MBNetworking'
  s.version          = '0.1.0'
  s.summary          = 'A short description of Networking.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'This cocoapod allows you to make quick and easy network requests without too much bloat. Currently it only supports GET. My main motivation for using this was really to get an idea how to unit test a network layer, and keep total control over my network requests'

  s.homepage         = 'https://github.com/Matt Beaney/Networking'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Matt Beaney' => 'beaneyios@gmail.com' }
  s.source           = { :git => 'https://github.com/Matt Beaney/Networking.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/beaneyios'

  s.ios.deployment_target = '10.0'

  s.source_files = 'Networking/Classes/**/*'
  
  s.test_spec 'Tests' do |test_spec|
      test_spec.source_files = 'NetworkingTests/**/*.{swift}'
      test_spec.dependency 'Quick', '~> 1.3.0'
      test_spec.dependency 'Nimble', '~> 7.1.1'
  end
  
  s.dependency 'CryptoSwift', '~> 0.9.0'
  
  # s.resource_bundles = {
  #   'Networking' => ['Networking/Assets/*.png']
  # }
  
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
end
