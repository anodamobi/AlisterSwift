Pod::Spec.new do |s|
  s.name             = 'AlisterSwift'
  s.version          = '1.0.0'
  s.summary          = 'Table Helper'
  s.description      = 'Table and Collection Helper'

  s.description      = <<-DESC
No more boilerplate code with tables and collections!
                       DESC
  s.homepage         = 'https://github.com/anodamobi/AlisterSwift'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Oksana Kovalchuk' => 'oksana@anoda.mobi',
                         'Alexander Kravchenko' => 'alex.kravchenko@anoda.mobi',
                         'Maxim Danilov' => 'maxim.danilov@anoda.mobi',
                         'Pavel Mosunov' => 'pavel.mosunov@anoda.mobi',
                         'Simon Kostenko' => 'simon.kostenko@anoda.mobi'
                        }
  s.source           = { :git => 'https://github.com/anodamobi/AlisterSwift.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/oks_ios'

  s.ios.deployment_target = '9.0'

  s.source_files = 'Sources/AlisterSwift/**/*'

  s.swift_version = '5.2'
end
