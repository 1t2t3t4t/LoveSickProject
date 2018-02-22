# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'LoveSick2' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
    pod 'ILLoginKit'
    pod 'Firebase'
    pod 'Firebase/Core'
    pod 'Firebase/Database'
    pod 'Firebase/Storage'
    pod 'Firebase/Auth'
    pod 'ObjectMapper', '~> 3.1'
    pod 'AlamofireImage', '~> 3.3'
    pod 'OneSignal', '>= 2.5.2', '< 3.0'
    pod 'UIEmptyState'
    pod 'AssistantKit'
    pod 'JGProgressHUD'
    pod 'Hokusai'
    pod 'Lightbox'
    pod 'FBSDKCoreKit'
    pod 'FBSDKLoginKit'
    pod 'ILLoginKit'
    pod 'ZAlertView'
    pod 'XLPagerTabStrip', '~> 8.0'
    pod 'NMessenger'
    pod 'Fusuma'
    pod 'KMPlaceholderTextView', '~> 1.3.0'
     pod 'Nuke', '~> 6.0'
  # Pods for LoveSick2

  target 'LoveSick2Tests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'LoveSick2UITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
target 'OneSignalNotificationServiceExtension' do
use_frameworks!
pod 'OneSignal', '>= 2.5.2', '< 3.0'
end
post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.name == 'NMessenger'
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.0'
            end
        end
    end
end

