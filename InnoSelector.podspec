Pod::Spec.new do |s|
    s.name = "InnoSelector"
    s.platform = :ios
    s.ios.deployment_target = '9.0'
    s.description = "A framework for filter selection with full customisation which will allow the user to have single and multi select functionalities with customising the table content, title, and button theme color"
    s.summary = "InnoSelector is drop in framework to manage the filter content for projects"
    s.requires_arc = true
    s.version = "1.0"
    s.license = { :type => "MIT", :file => "LICENSE" }
    s.author = { "Gopinath A" => "gopinath.a@innoplexus.com" }
    s.homepage = "https://github.com/Innoplexus-Consulting-Services/InnoSelector"
    s.source = { :git => "https://github.com/Innoplexus-Consulting-Services/InnoSelector.git", :tag => "1.00"}
    s.framework = ["UIKit"]
    s.dependency 'Alamofire'
    s.dependency 'ObjectMapper'
    s.source_files = ["InnoSelector/**/*.{swift}"]
    s.resource_bundles = {
        'Storyboards' => [
        'InnoSelector/**/*.storyboard'
        ]
    }
    pushed_with_swift_version = '3.1'
end
