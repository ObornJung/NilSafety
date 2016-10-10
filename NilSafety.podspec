
Pod::Spec.new do |s|

  s.name         = "NilSafety"
  s.version      = "1.0.0"
  s.summary      = "Safety cushion."

  s.description      = <<-DESC
     How we made NSArray、NSMutableArray、NSDictionary、NSMutableDictionary nil safe at Glow..
                       DESC

  s.homepage     = "https://github.com/ObornJung/NilSafety"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Oborn.Jung" => "obornjung@gmail.com" }
  s.authors      = { "Oborn.Jung" => "obornjung@gmail.com" }
  
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/ObornJung/NilSafety.git", :tag => s.version }

  s.source_files  = "NilSafety/**/*"
  s.public_header_files = 'NilSafety/**/*.h'
   
  s.frameworks  = "Foundation", "UIKit"

  s.requires_arc = true

end
