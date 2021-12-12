#
#  Be sure to run `pod spec lint Nuke-WebP-Plugin.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|


  s.name                = "Nuke-AVIF-Plugin"
  s.version             = "1.0.0"
  s.summary             = "Nuke's AVIF plugin which can load and display AVIF"

  s.homepage            = "https://github.com/delneg/Nuke-AVIF-Plugin"

  s.license             = 'MIT'


  s.author              = { "delneg" => "delneg@yandex.ru" }

  s.ios.deployment_target = '11.0'
  s.osx.deployment_target  = '10.13'
  s.tvos.deployment_target = "11.0"
  s.watchos.deployment_target = "4.0"

  s.source              = { :git => "https://github.com/delneg/Nuke-AVIF-Plugin.git", :tag => "v#{s.version}" }

  s.source_files        = "Source/**/*"
  s.public_header_files = "Source/**/*.h"
  s.pod_target_xcconfig = {
      'HEADER_SEARCH_PATHS' => '$(inherited) ${PODS_ROOT}/libavif/include',
  }

  s.swift_version     = ['5.1', '5.2']
  s.requires_arc      = true
  s.module_name       = 'NukeAVIFPlugin'

  s.dependency 'libavif', '>= 0.9.1'
  s.dependency 'Nuke', '~> 9.0'
  s.libraries = 'c++'

end
