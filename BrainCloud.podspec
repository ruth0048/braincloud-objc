#
#  BrainCloud.podspec
#  BrainCloud
#
#  Created by Benoit Sarrazin on Feb 11, 2016.
#  Copyright (c) 2016 BitHeads Inc. All rights reserved.
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.name     = "BrainCloud"
  s.version  = "2.21.2"
  s.summary  = "The Objective-C/Swift client library for brainCloud"
  s.homepage = "http://getbraincloud.com/"

  s.ios.deployment_target  = "6.0"
  s.osx.deployment_target  = "10.8"
  s.tvos.deployment_target = "9.0"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.license                = {:type => "Apache License, Version 2.0", :file => "LICENSE"}

  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.authors                = {"Preston Jennings" => "prestonj@bitheads.com"}
  s.social_media_url       = "https://twitter.com/braincloudbaas"

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.source                 = {:git => "https://github.com/getbraincloud/braincloud-objc.git", :tag => s.version}

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.header_mappings_dir    = 'Shared'
  s.public_header_files    = 'Shared/**/*.{h,hh}'
  s.private_header_files   = 'Shared/**/{BrainCloudCallback,TypeHelpers}.hh'
  s.source_files           = 'Shared/**/*.{h,hh,m,mm}'

  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.libraries                = 'c++', 'z'

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.dependency 'BrainCloudCpp', '2.21.1'
  s.dependency 'SSKeychain', '1.3.1'

end
