
Pod::Spec.new do |s|
  s.name             = 'DummyFramework'
  s.version          = '1.0.0'
  s.summary          = 'CalsSDK'
  s.description      = 'CalsSDK this is a framework for App'
  s.homepage         = 'https://www.cocoapods.org'
  s.license          = 'MIT (iOS)'
  s.author           = { 'Tiara Mahardika' => 'tiara.mahardika@digitalcenter.id' }
  s.source           = { :git => 'http://syddvwn@github.com/syddvwn/LearningDummyFramework.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'DummyFramework/DummyFramework/Modules/**/*.{h,m,swift}'
  
  s.resources = "DummyFramework/DummyFramework/Assets/**/*.{storyboard,xib,xcassets,json,imageset,png,plist,html}"

   #s.public_header_files = 'Pod/Classes/**/*.h'
  #  s.dependency 'MaintenanceView'


end