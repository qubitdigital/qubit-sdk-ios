Pod::Spec.new do |s|

    s.name         = "QubitSDK"
    
    s.version      = "2.0.0"
    
    s.summary      = "Qubit experience delivery for iOS"
    
    s.description  = <<-DESC
    Qubit experience delivery for iOS
    DESC
    
    s.homepage     = "http://www.qubit.com"
    
    #TODO: change license
    s.license      = { :type => 'MIT', :file => 'LICENSE' }
    
    s.authors      = { "Dariusz Zajac" => "dariusz.zajac@miquido.com", "Pavlo Davydiuk" => "pavlo.davydiuk@miquido.com" }
    
    s.platform     = :ios, "9.0"
    
    s.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.0', "ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES" => "NO" }
    
    s.source       = { :git => "https://github.com/qubitdigital/qubit-sdk-ios.git", :tag => "#{s.version}" }
    s.source_files = 'QBTracker/QubitSDK/**/*.{swift}'
    s.resources = 'QBTracker/QubitSDK/Database/*.{xcdatamodeld}'
    s.framework  = "CoreData"
    s.swift_versions = ['4.0', '4.1', '4.2', '5.0', '5.1', '5.2', '5.3']
    
    end
