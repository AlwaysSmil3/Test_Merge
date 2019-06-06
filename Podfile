# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'FinPlus' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  pod 'IBAnimatable'
  pod 'SwiftyJSON'
  pod 'PromiseKit'
  pod 'TPKeyboardAvoiding'
  pod 'PulsingHalo'
  pod 'Alamofire'
  pod 'ObjectMapper'
  pod 'NVActivityIndicatorView'
  pod 'SDWebImage'
  pod 'FBSDKCoreKit'
  pod 'FBSDKLoginKit'
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  pod 'Firebase/RemoteConfig'
  pod 'SpreadsheetView'
  pod 'PinCodeTextField'
  pod 'Fabric'
  pod 'Crashlytics'
  pod 'SVProgressHUD'
  pod 'DateToolsSwift'
  pod 'APAddressBook/Swift'
  pod 'MYTableViewIndex'

  # Pods for FinPlus

end

# Workaround for Cocoapods issue #7606
post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end
