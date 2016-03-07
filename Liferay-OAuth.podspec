Pod::Spec.new do |s|
	s.name					= "Liferay-OAuth"
	s.module_name			= "LROAuth"
	s.version				= "1.2.0"
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
	s.ios.deployment_target	= "7.0"
	s.source				= {
								:git => "https://github.com/brunofarache/liferay-ios-sdk-oauth.git",
								:tag => "1.2.0"
							}
	s.source_files			= "{Source}/**/*"
	s.dependency			"Liferay-iOS-SDK", "7.0.3"
end