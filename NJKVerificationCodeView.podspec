Pod::Spec.new do |spec|

  spec.name           	 = 'NJKVerificationCodeView'

  spec.version        	 = '0.0.1'

  spec.summary        	 = 'A validation box that can be expanded freely'

  spec.description  	   = 'A verification code used for a certain number of digits'

  spec.homepage       	 = 'https://github.com/jiangkuoniu/codeViewDemo'

  spec.license        	 = 'MIT'

  spec.authors        	 = {'NJK' => '707429313@qq.com'}

  spec.platform       	 = :ios, '9.0'

  spec.source            = {:git => 'https://github.com/jiangkuoniu/codeViewDemo.git', :tag => "#{spec.version}"}



  spec.source_files     = 'NJKVerificationCodeView/NJKVerificationCodeViewHeader.h'

  spec.subspec 'CodeView' do |codeview|
  codeview.source_files = 'NJKVerificationCodeView/CodeView/*.{h,m}'
  end



  spec.requires_arc   	 = true

  spec.framework 		     = 'UIKit' 

  spec.dependency 'Masonry', '~> 1.1.0' 

end
