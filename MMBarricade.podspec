Pod::Spec.new do |s|
  s.name         = "MMBarricade"
  s.version      = "1.0.1"
  s.summary      = "Framework for setting up a run-time configurable local server in iOS apps."
  s.homepage     = "https://github.com/MutualMobile/MMBarricade"
  s.authors      = { 'John McIntosh' => 'john.mcintosh@mutualmobile.com' }
  s.license      = "MIT"

  s.ios.deployment_target = '7.0'
  s.source       = { :git => "https://github.com/MutualMobile/MMBarricade.git", :tag => s.version.to_s }
  s.frameworks = 'Foundation', 'CFNetwork'
  s.requires_arc = true
  s.default_subspec = 'Core'
  
  s.subspec 'Core' do |core|
    core.source_files = "Barricade/Core/**/*.{h,m}"
    core.public_header_files = "Barricade/Core/**/*.h"
    core.exclude_files = "Barricade/Core/**/*Tests.m"
  end  
  
  s.subspec 'Tweaks' do |tweaks|
    tweaks.dependency 'MMBarricade/Core'
    tweaks.dependency 'Tweaks', '~> 2.0'
    tweaks.source_files = "Barricade/Tweaks/**/*.{h,m}"
    tweaks.public_header_files = "Barricade/Tweaks/**/*.h"
    tweaks.exclude_files = "Barricade/Tweaks/**/*Tests.m"
  end
end
