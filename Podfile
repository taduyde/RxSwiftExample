# Uncomment the next line to define a global platform for your projecti
# platform :ios, '9.0'

target 'ReactiveXTimeline' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  # Pods for ReactiveXTimeline
  pod 'RxSwift', '~> 3.3'
  pod 'RxCocoa', '~> 3.3'
  pod 'Alamofire', '~> 4.4'
  
  target 'ReactiveXTimelineTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ReactiveXTimelineUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
            config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '10.10'
        end
    end
end

