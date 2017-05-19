
Pod::Spec.new do |s|
  s.name         = "VisualKit"
  s.version      = "0.0.1"
  s.summary      = "Visual Engineering UI Code"
  s.homepage     = "http//www.visual-engin.com"
  s.license      = "MIT"
  s.author       = { "Jordi Serra" => "jserra@visual-engin.com" }

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.platform     = :ios, "9.0"

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source       = { :path => "." }

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source_files  = "Source/**/*.{swift,m,h}"

  # ――― Dependencies ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

end
