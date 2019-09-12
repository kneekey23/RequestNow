# Uncomment the next line to define a global platform for your project
 platform :ios, '12.2'

target 'RequestNow' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for RequestNow
 pod 'Alamofire', '~> 4.8.2'
 pod 'AlamofireObjectMapper', '~> 5.2.1'
 pod 'SwiftyJSON'

	post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '5.0'
    end
  end
end

end
