# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

# Shared Pods across all targets
def all_pods
    # Analytics
    pod 'FBSDKCoreKit' , '~> 5.8.0'
    pod 'FBSDKLoginKit' , '~> 5.8.0'
    pod 'FBSDKShareKit' , '~> 5.8.0'
    pod 'Fabric' , '~> 1.10.2'
    pod 'Crashlytics' , '~> 3.14.0'
    pod 'KochavaTrackeriOS' , '~> 3.8.0'
    pod 'OneSignal', '~> 2.12.6'
    
    # Database
    pod 'MagicalRecord' , '~> 2.3.2'
    #pod 'Parse', :git => 'https://github.com/parse-community/Parse-SDK-iOS-OSX.git', :branch => 'master'
    pod 'Parse' , '~> 1.19.2'
    pod 'SimpleKeychain' , '~> 0.8.1'
    
    # Impera
    pod 'Impera/StoreKit', :git => 'https://bitbucket.org/appstore-pirates/impera-pods.git', :branch => 'release/server-receipt-validation/0.4'
    pod 'Impera/AnalyticsKit', :git => 'https://bitbucket.org/appstore-pirates/impera-pods.git', :branch => 'release/server-receipt-validation/0.4'
    pod 'OpenSSL-Universal'
    
    # Networking
    pod 'AFNetworking' , '~> 4.0'
    pod 'Firebase' , '~> 5.16.0'
    
    # UI
    pod 'MBProgressHUD' , '~> 1.1.0'
    pod 'CHTCollectionViewWaterfallLayout' , '~> 0.9.7'
    pod 'LUNSegmentedControl' , '~> 1.0.7'
    pod 'iCarousel' , '~> 1.8.3'
    pod 'Ono' , '~> 2.1.1'
    pod 'DZNEmptyDataSet' , '~> 1.8.1'
    pod 'PKYStepper' , '~> 0.0.1'
end

target 'GenericEO' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  #use_frameworks!

  # Pods for MyEO Generic (GENERIC)
  all_pods

  target 'GenericEOTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'GenericEOUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

target 'MyEO-doTERRA' do
    # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
    #use_frameworks!
    
    # Pods for MyEO doTERRA (ESTL, DOTERRA)
    all_pods
    
end

target 'MyEO-YoungLiving' do
    # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
    #use_frameworks!
    
    # Pods for MyEO YoungLiving (ESTL, YOUNGLIVING)
    all_pods
    
end

target 'AB-doTERRA' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  #use_frameworks!
  
  # Pods for AB doTERRA (AB, DOTERRA)
  all_pods
  
end


target 'AB-YL' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  #use_frameworks!
  
  # Pods for AB-YoungLiving (AB, YOUNGLIVING)
  all_pods
  
end

target 'OneSignalNotificationServiceExtension' do
    pod 'OneSignal', '~> 2.12.6'
end


