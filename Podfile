source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'

inhibit_all_warnings!
use_frameworks!

target :DominantInvestors do
    pod 'ObjectMapper', '2.2.4'
    pod 'AlamofireObjectMapper', '4.1.0'

end

target :DominantCrypto do
    pod 'ObjectMapper', '2.2.4'
    pod 'AlamofireObjectMapper', '4.1.0'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.1'
        end
    end
end
