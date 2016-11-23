
Pod::Spec.new do |s|
  s.name             = 'JHTAlertController'
  s.version          = '0.1.6'
  s.summary          = 'A stock replacement for UIAlertController to customize the colors, fonts, and images to suit your needs.'

  s.description      = <<-DESC
JHTAlertController is a replacement for the stock UIAlertController. With it, you can customize the background colors, text colors, and add images to the alert.
                       DESC

  s.homepage         = 'https://github.com/jjessel/JHTAlertController'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jeremiah Jessel' => 'Jacuzzi Hot Tubs, LLC' }
  s.source           = { :git => 'https://github.com/jjessel/JHTAlertController.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/jcubedapps'

  s.ios.deployment_target = '9.0'

  s.source_files = 'Source/*'

end
