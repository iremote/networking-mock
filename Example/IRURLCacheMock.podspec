Pod::Spec.new do |s|

    s.name         = "IRURLCacheMock"
    s.version      = "1.0.0"
    s.summary      = "NSURLCache Mock."

    s.description  = <<-DESC
                        NSURLCache Mock framework for Unit testing.
                    DESC

    s.homepage     = "http://www.iremote.net"
    s.license      = "MIT"

    s.author       = { "Ramesh" => "rdoddi@iremote.net" }

    s.source       = { :git => "https://github.com/iremote/url-cache-mock.git", :tag => s.version.to_s }

    s.ios.deployment_target = '7.0'

    s.ios.source_files = "Pod/Classes/*.{h,m}"

    s.requires_arc = true

end
