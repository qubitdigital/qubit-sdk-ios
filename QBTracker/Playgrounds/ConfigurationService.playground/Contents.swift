import UIKit
import PlaygroundSupport
@testable import QubitSDK

let service = QBConfigurationManager(withTrackingId: "miquido", withDeleagte: QBTracker.shared)

print(service.getEventEndpoint())

PlaygroundPage.current.needsIndefiniteExecution = true
