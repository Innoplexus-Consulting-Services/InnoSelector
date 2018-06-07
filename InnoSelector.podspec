Pod::Spec.new do |s|
    s.name = "InnoSelector"
    s.platform = :ios
    s.ios.deployment_target = '9.0'
    s.description = "A framework for data selection which has the option for both single and multi-select functionalities. In this, you can also customise the attributes like how the view should present, what will be the title and its colour, whether the table content should have the image or not, colour for the title and subtitle of the table content, bottom theme colour and much more."
    s.summary = "InnoSelector is drop in framework to manage the filter content for projects"
    s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
    s.swift_version = '4.0'
    s.requires_arc = true
    s.version = "1.1"
    s.license = { :type => "MIT", :file => "LICENSE" }
    s.author = { "Gopinath A" => "gopinath.a@innoplexus.com" }
    s.homepage = "https://github.com/Innoplexus-Consulting-Services/InnoSelector"
    s.source = { :git => "https://github.com/Innoplexus-Consulting-Services/InnoSelector.git", :tag => "1.1"}
    s.framework = ["UIKit"]
    s.source_files = ["InnoSelector/**/*.{swift}"]
    s.resources = 'Resources/**/*.storyboard'
end
