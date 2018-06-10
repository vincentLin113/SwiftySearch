#
#  Be sure to run `pod spec lint SwiftySearch.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "SwiftySearch"
  s.version      = "1.0.3"
  s.summary      = "Awesome iOS UISearchController with multi-feature."
  s.description  = "Search History + Hot Search + Customization + Localized SearchController"
  s.homepage     = "https://github.com/vincentLin113/SwiftySearch"
  s.license      = "MIT"
  s.author       = { "VincentLin" => "keepexcelsior@gmail.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/vincentLin113/SwiftySearch.git", :tag => "#{s.version}" }
  s.source_files  = "SwiftySearch/Source/*.{swift,metal,h,m}"
  s.resources     = "SwiftySearch/Source/SwiftySearchResource.bundle", "SwiftySearch/Source/**/*.strings"
  s.swift_version = '3.3'
end
