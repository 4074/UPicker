#
#  Be sure to run `pod spec lint UPicker.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "UPicker"
  s.version      = "0.1.1"
  s.summary      = "A picker widget written in Swift which is lightweight and extensible."
  s.homepage     = "https://github.com/4074/UPicker"
  s.license      = "MIT"
  s.author       = { "4074" => "fourzerosevenfour@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/4074/UPicker.git", :tag => "0.1.1" }
  s.source_files = "UPicker/*.swift"
  s.frameworks   = ['UIKit']
end
