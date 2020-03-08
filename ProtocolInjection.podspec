
Pod::Spec.new do |s|
  s.name             = 'ProtocolInjection'
  s.version          = '1.0.3'
  s.summary          = 'Default implementation of protocol optional methods'



  s.description      = <<-DESC
                        Default implementation of protocol optional methods
                        DESC

  s.homepage         = 'https://github.com/GodL/ProtocolInjection'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '547188371@qq.com' => 'GodL' }
  s.source           = { :git => 'https://github.com/GodL/ProtocolInjection.git', :tag => s.version.to_s }

  s.platform     = :ios, '6.0'
  s.ios.deployment_target = '6.0'

  s.source_files = 'ProtocolInjection/ProtocolInjection/ProtocolInjection/*.{h,m}'
  s.ios.public_header_files = 'ProtocolInjection/ProtocolInjection/ProtocolInjection/*.h'
  s.frameworks = 'CoreFoundation'
end
