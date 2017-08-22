import UIKit
import PlaygroundSupport
@testable import QBTracker

defaultConfigurationService.getConfigution(forId: "roeld") { result in
    switch result {
    case .success(let config):
        print("config = \(config) \n")
    case .failure(let error):
        print("error = \(error) \n")
    }
}

PlaygroundPage.current.needsIndefiniteExecution = true
