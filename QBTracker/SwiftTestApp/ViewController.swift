//
//  ViewController.swift
//  SwiftTestApp
//
//  Created by Dariusz Zajac on 23/08/2017.
//  Copyright © 2017 Qubit. All rights reserved.
//

import UIKit
import QubitSDK
//@testable import QBTracker

class ViewController: UIViewController {

    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        QubitSDK.start(withTrackingId: "miquido", logLevel: .verbose)
    }
    
    @IBAction func tapOnEventButton(_ sender: UIButton) {
        QubitSDK.sendEvent(type: "View", data: "{\"type\" : \"tapOnEventButton\"}")
        
        DispatchQueue.global(qos: .background).async {
            QubitSDK.sendEvent(type: "View_Background", data: "{\"type\" : \"tapOnEventButton\"}")
        }
    }
    
    @IBAction func tapOnCreateEventButton(_ sender: UIButton) {
        let event =  QubitSDK.createEvent(type: "Product", dictionary: ["eventType": "tapOnCreateEventButton"])
        QubitSDK.sendEvent(event: event)
    }
}
