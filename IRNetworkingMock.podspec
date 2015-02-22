Pod::Spec.new do |s|

    s.name         = "IRNetworkingMock"
    s.version      = "1.0.0"
    s.summary      = "Networking Mock."

    s.description  = <<-DESC
                        Networking Mock framework for Unit testing.
                    DESC

    s.homepage     = "http://www.iremote.net"
    s.license      = "MIT"

    s.author       = { "Ramesh" => "rdoddi@iremote.net" }

    s.source       = { :git => "https://github.com/iremote/networking-mock.git", :tag => s.version.to_s }

    s.ios.deployment_target = '7.0'

    s.ios.source_files = "Pod/Classes/*.{h,m}"

    s.requires_arc = true

end
