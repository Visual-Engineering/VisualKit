
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

  s.subspec 'Source' do |cs|
    cs.source_files = 'Source/Rating/TagsView/TagsView.m'
    cs.public_header_files = 'Source/VisualKit.h', 'Source/Rating/TagsView/TagsView.h'
  end

  # ――― Dependencies ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

end
