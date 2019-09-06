# Uncomment the next line to define a global platform for your project
 platform :ios, '10.0'

target 'Swapi' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Swapi
  pod 'Alamofire', '~> 4.8.2'
  pod 'SwiftyJSON', '~> 4.2'

  target 'SwapiTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'Alamofire', '~> 4.8.2'
    pod 'SwiftyJSON', '~> 4.2'
  end

  target 'SwapiUITests' do
    inherit! :search_paths
    # Pods for testing
    pod 'Alamofire', '~> 4.8.2'
    pod 'SwiftyJSON', '~> 4.2'
  end
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '4.2'
      end
    end
  end

end
