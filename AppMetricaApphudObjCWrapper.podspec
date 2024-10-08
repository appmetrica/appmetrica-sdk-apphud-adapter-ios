Pod::Spec.new do |s|
  s.name = "AppMetricaApphudObjCWrapper"
  s.version = '1.1.0'
  s.summary = "Automatically starts and configures Apphud within AppMetrica."

  s.homepage = 'https://appmetrica.io'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.authors = { "AppMetrica" => "admin@appmetrica.io" }
  s.source = { :git => "https://github.com/appmetrica/appmetrica-sdk-apphud-adapter-ios.git", :tag => s.version.to_s }
  
  s.ios.deployment_target = '13.0'
  s.tvos.deployment_target = '13.0'

  s.frameworks = 'Foundation'
  
  s.swift_version = '5.0'

  s.dependency 'ApphudSDK', '~> 3.0'
  s.dependency 'AppMetricaCore', '~> 5.8'
  s.dependency 'AppMetricaCoreExtension', '~> 5.8'
  s.dependency 'AppMetricaStorageUtils', '~> 5.8'
  
  s.source_files = "#{s.name}/Sources/**/*.{swift}"
  
  s.resource_bundles = { s.name => "#{s.name}/Sources/Resources/PrivacyInfo.xcprivacy" }
end
