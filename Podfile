# Uncomment the next line to define a global platform for your project
platform :ios, '13.1'

def shared_pods
  # Pods for all targets
  pod 'Alamofire'
  pod 'ExytePopupView'
  pod 'PusherSwift', '8.0.0'
  pod 'ReachabilitySwift'
  pod 'SwiftyJSON'
end

target 'Customer' do
  use_frameworks!
  shared_pods

  # Pods for Customer
  pod 'Introspect'
  pod 'Kingfisher/SwiftUI'
  pod 'Stripe'
end

target 'Server' do
  use_frameworks!
  shared_pods

  # Pods for Server
end
