Pod::Spec.new do |s|

  s.name         = "ResignOnMissTextView"
  s.version      = "0.0.2"
  s.summary      = "ResignOnMissTextView will resign when a user taps off of the view."
  s.description  = "This pod implements a new text view that will listen for a notification to know when to resign itself to allow for resignign when a user taps anywhere but the text view. A placeholder has also been added to this textview."
  s.homepage     = "https://github.com/campierce88/ResignOnMissTextView.git"
  s.license      = { :type => "Apache", :file => "LICENSE" }
  s.author             = "Cameron Pierce"
  s.social_media_url   = "http://twitter.com/campierce88"
  s.platform     = :ios
  s.ios.deployment_target = '8.0'
  s.source       = { :git => "https://github.com/campierce88/ResignOnMissTextView.git", :tag => "#{s.version}" }
  s.source_files  = "ResignOnMissTextView/**/*.{swift}"
  # s.framework  = "UIKit"

end
