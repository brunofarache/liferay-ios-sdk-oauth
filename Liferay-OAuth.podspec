Pod::Spec.new do |s|
	s.name					= "Liferay-OAuth"
	s.module_name			= "LROAuth"
	s.version				= "0.1.0"
	s.summary				= "Liferay iOS SDK OAuth"
	s.homepage				= "https://github.com/brunofarache/liferay-ios-sdk-oauth"
	s.license				= {
								:type => "LPGL 2.1",
								:file => "copyright.txt"
							}
	s.authors				= {
								"Bruno Farache" => "bruno.farache@liferay.com"
							}
	s.platform				= :ios
	s.ios.deployment_target	= '8.0'
	s.source				= {
								:git => "https://github.com/brunofarache/liferay-ios-sdk-oauth.git",
								:tag => "0.1.0"
							}
	s.source_files			= "{Source}/**/*"
	s.dependency			"Liferay-iOS-SDK", "6.2.0.17"
end