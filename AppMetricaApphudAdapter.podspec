Pod::Spec.new do |s|
  s.name = "AppMetricaApphudAdapter"
  s.version = '1.0.0'
  s.summary = "Automatically starts and configures Apphud within AppMetrica."

  s.homepage = 'https://appmetrica.io'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.authors = { "AppMetrica" => "admin@appmetrica.io" }
  s.source = { :git => "https://github.com/appmetrica/appmetrica-sdk-apphud-adapter-ios.git", :tag=>s.version.to_s }
  
  s.ios.deployment_target = '13.0'
  s.tvos.deployment_target = '13.0'
  
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }

  s.frameworks = 'Foundation'
  
  s.swift_version = '5.0'
  
  s.dependency 'AppMetricaCore', '~> 5.8'
  s.dependency 'AppMetricaCoreExtension', '~> 5.8'
  s.dependency 'AppMetricaApphudObjCWrapper', '= 1.0.0'
  
  s.header_dir = s.name
  s.source_files = "#{s.name}/Sources/**/*.{h,m}"
  s.public_header_files = "#{s.name}/Sources/include/**/*.h"
  
  s.resource_bundles = { s.name => "#{s.name}/Sources/Resources/PrivacyInfo.xcprivacy" }
end
