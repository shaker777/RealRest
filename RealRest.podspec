Pod::Spec.new do |s|
  s.name             = 'RealRest'
  s.version          = '0.2.1'
  s.summary          = 'Controller executor'
  s.description      = <<-DESC
 Part of the Controller in modern MVC                       
                       DESC
  s.homepage         = 'https://github.com/realestimationteam/RealRest.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'RealEstimation' => 'info@realestimation.com' }
  s.source           = { :git => 'https://github.com/realestimationteam/RealRest.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files = 'Sources/**/*'
  # s.resources = 'RealRest/Assets/*.{xib,xcassets,png,jpg,otf,ttf}'

  s.dependency 'Alamofire', '4.7.3'
  s.dependency 'BrightFutures', '7.0.0'
  s.dependency 'EVReflection', '5.7.0'
  s.dependency 'MBProgressHUD', '1.1.0'
end
